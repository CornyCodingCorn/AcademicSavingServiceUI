using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.ComponentModel;
using PropertyChanged;
using System.Collections;
using System.Threading.Tasks;
using System.Threading;
using System.Collections.Generic;
using System.Windows.Input;
using System.Windows.Media;
using System;

namespace AcademicSavingService.Controls
{
	/// <summary>
	/// Interaction logic for AssDataGrid.xaml
	/// </summary>
	[AddINotifyPropertyChangedInterface]
	public partial class AssDataGrid : UserControl, INotifyPropertyChanged
	{
		public event PropertyChangedEventHandler PropertyChanged = (s, e) => { };

		public static readonly DependencyProperty EnableFullTextSearchProperty =
			DependencyProperty.Register("EnableFullTextSearch", typeof(bool), typeof(AssDataGrid), new PropertyMetadata(OnItemsSourceChangedCallBack));
		public bool EnableFullTextSearch
		{
			get { return (bool)GetValue(EnableFullTextSearchProperty); }
			set { SetValue(EnableFullTextSearchProperty, value); }
		}

		public static readonly DependencyProperty ItemsSourceProperty =
			DependencyProperty.Register("ItemsSource", typeof(IEnumerable), typeof(AssDataGrid));
		public IEnumerable ItemsSource 
		{ 
			get { return (IEnumerable)GetValue(ItemsSourceProperty); }
			set { SetValue(ItemsSourceProperty, value); }
		}
		private static void OnItemsSourceChangedCallBack(
			DependencyObject sender, DependencyPropertyChangedEventArgs e)
		{
			AssDataGrid c = sender as AssDataGrid;
			if (c != null)
			{
				c.OnItemsSourceChanged(e);
			}
		}

		public static readonly DependencyProperty DataGridNameProperty =
			DependencyProperty.Register("DataGridName", typeof(string), typeof(AssDataGrid));
		public string DataGridName
		{
			get { return (string)GetValue(DataGridNameProperty); }
			set { SetValue(DataGridNameProperty, value); }
		}

		public int ItemsSize
		{
			get { return dataGrid.Items.Count; }
		}

		public ItemCollection Items
		{
			get { return dataGrid.Items; }
		}

		public static readonly DependencyProperty SearchTextProperty =
			DependencyProperty.Register("SearchText", typeof(string), typeof(AssDataGrid));
		public string SearchText
		{
			get { return (string)GetValue(SearchTextProperty); }
			set { SetValue(SearchTextProperty, value); }
		}

		public ObservableCollection<DataGridColumn> Columns
		{ get { return dataGrid.Columns; } }

		//Selected stuff
		public static readonly DependencyProperty SelectedItemProperty =
			DependencyProperty.Register("SelectedItem", typeof(object), typeof(AssDataGrid));
		public object SelectedItem
		{
			get { return GetValue(SelectedItemProperty); }
			set { SetValue(SelectedItemProperty, value); }
		}

		public IList SelectedItems
		{
			get { return dataGrid.SelectedItems; }
		}

		public static readonly DependencyProperty SelectedIndexProperty =
			DependencyProperty.Register("SelectedIndex", typeof(int), typeof(AssDataGrid));
		public int SelectedIndex
		{
			get { return (int)GetValue(SelectedIndexProperty); }
			set { SetValue(SelectedIndexProperty, value); }
		}

		protected CancellationTokenSource cancelCulture;
		protected bool isSearching = false;
		protected Task currentSearch;

		public AssDataGrid()
		{
			InitializeComponent();
			content.DataContext = this;
			this.Loaded += (s, e) =>
			{
				StartSearch();
			};
		}

		private void ScrollViewer_PreviewMouseWheel(object sender, MouseWheelEventArgs e)
		{
			ScrollViewer scrollViewer = (ScrollViewer)sender;
			scrollViewer.ScrollToVerticalOffset(scrollViewer.VerticalOffset - e.Delta);
		}

		protected void txtFullTextSearch_TextChanged(object sender, TextChangedEventArgs e)
		{
			StartSearch();
		}

		private static readonly RoutedEvent ItemsSourceChangedEvent = 
			EventManager.RegisterRoutedEvent("ItemsSourceChanged", RoutingStrategy.Bubble, typeof(RoutedEventHandler), typeof(AssDataGrid));
		public event RoutedEventHandler ItemsSourceChanged
		{
			add { AddHandler(ItemsSourceChangedEvent, value); }
			remove { RemoveHandler(ItemsSourceChangedEvent, value); }
		}
		protected virtual void OnItemsSourceChanged(DependencyPropertyChangedEventArgs e)
		{
			RoutedEventArgs newEventArgs = new RoutedEventArgs(ItemsSourceChangedEvent);
			RaiseEvent(newEventArgs);
			if (EnableFullTextSearch && this.IsLoaded)
				StartSearch();
		}

		protected void StartSearch()
		{
			if (isSearching && cancelCulture != null)
			{
				cancelCulture.Cancel();
				currentSearch.Wait();
				cancelCulture.Dispose();
			}
			cancelCulture = new CancellationTokenSource();
			currentSearch = Search((SearchText ?? "").ToLower(), ItemsSize, cancelCulture);
		}

		protected Task Search(string searchText, int size, CancellationTokenSource token)
		{
			isSearching = true;
			Task task = null;

			task = Task.Run(() =>
			{
				int counter = 0;
				for (int i = 0; i < size; i++)
				{
					dataGrid.Dispatcher.Invoke(() =>
					{
						DataGridRow row = (DataGridRow)dataGrid.ItemContainerGenerator.ContainerFromIndex(i);
						bool show = false;
						foreach (DataGridColumn column in dataGrid.Columns)
						{
							if (column.GetCellContent(row) is TextBlock)
							{
								TextBlock cellContent = column.GetCellContent(row) as TextBlock;
								if (cellContent.Text.ToLower().Contains(searchText))
								{
									row.Style = GetColorFromCounter(counter);
									counter ++;
									show = true;
									break;
								}
							}
						}
						if (show)
							row.Visibility = Visibility.Visible;
						else
						{
							row.Visibility = Visibility.Collapsed;
							if (SelectedIndex == i)
								SelectedIndex++;
						}
					});

					if (token.IsCancellationRequested)
						break;
				}
			});

			return task;
		}

		protected Style GetColorFromCounter(int counter)
		{
			if (counter % 2 == 0)
				return this.FindResource("EvenRowStyle") as Style;
			else
				return this.FindResource("OddRowStyle") as Style;
		}
	}
}
