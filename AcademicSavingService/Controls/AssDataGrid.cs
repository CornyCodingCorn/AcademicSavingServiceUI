using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace AcademicSavingService.Controls
{
	public class AssDataGrid : DataGrid
	{
		public static readonly DependencyProperty FilterItemsProperty = 
			DependencyProperty.Register("FilterItems", typeof(ObservableCollection<object>), typeof(AssDataGrid));

		public static readonly DependencyProperty SelectedFilterItemProperty =
			DependencyProperty.Register("SelectedFilterItem", typeof(object), typeof(AssDataGrid));

		public static readonly DependencyProperty SelectedFilterIndexProperty =
			DependencyProperty.Register("SelectedFilterIndex", typeof(int), typeof(AssDataGrid));

		public ObservableCollection<object> FilterItems
		{
			get { return (ObservableCollection<object>)GetValue(FilterItemsProperty); }
			set { SetValue(FilterItemsProperty, value); }
		}

		public object SelectedFilter
		{
			get { return (object)GetValue(SelectedFilterItemProperty); }
			set { SetValue(SelectedFilterItemProperty, value); }
		}

		public int SelectedFilterIndex
		{
			get { return (int)GetValue(SelectedFilterIndexProperty); }
			set { SetValue(SelectedFilterIndexProperty, value); }
		}
	}
}
