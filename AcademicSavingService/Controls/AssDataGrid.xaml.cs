using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.ComponentModel;
using PropertyChanged;
using System.Collections;
using System.Threading.Tasks;
using System.Threading;
using System.Collections.Generic;

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
			DependencyProperty.Register("EnableFullTextSearch", typeof(bool), typeof(AssDataGrid));
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

		public int ItemsSize
		{
			get { return dataGrid.Items.Count; }
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
		}

		protected async void txtFullTextSearch_TextChanged(object sender, TextChangedEventArgs e)
		{
			if (isSearching && cancelCulture != null)
			{
				cancelCulture.Cancel();
				await currentSearch;
				cancelCulture.Dispose();
			}
			cancelCulture = new CancellationTokenSource();
			currentSearch = Search(SearchText, ItemsSize, cancelCulture);
		}

		protected Task Search(string searchText, int size, CancellationTokenSource token)
		{
			isSearching = true;
			Task task = null;

			task = Task.Run(() =>
			{
				for (int i = 0; i < size; i++)
				{
					dataGrid.Dispatcher.Invoke(() =>
					{
						DataGridRow row = (DataGridRow)dataGrid.ItemContainerGenerator.ContainerFromIndex(i);
						bool show = false;
						foreach (var item in dataGrid.Items[i].GetType().GetProperties())
						{
							if (System.Convert.ToString(item.GetValue(dataGrid.Items[i])).ToLower().Contains(searchText))
							{
								show = true;
								break;
							}
						}
						if (show)
							row.Visibility = Visibility.Visible;
						else
							row.Visibility = Visibility.Collapsed;
					});

					if (token.IsCancellationRequested)
						throw new TaskCanceledException(task);
				}
			});

			return task;
		}
	}
}
