using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.ComponentModel;
using System.Windows;
using System.Windows.Media.Animation;
using System.Windows.Media;
using System.Threading;
using System.Windows.Controls.Primitives;
using System.Collections.Specialized;

namespace AcademicSavingService.Animation
{
	public class TabControlSweptAnimated : TabControl
	{
        public static double DefaultInDuration { get; } = 0.3;
        public static double DefaultOutDuration { get; } = 0.2;

		public static readonly DependencyProperty AnimationInDurationProperty = DependencyProperty.Register("AnimationInDuration", typeof(double), typeof(TabControlSweptAnimated), new PropertyMetadata(DefaultInDuration));
		public double AnimationInDuration
		{ 
			get { return (double)GetValue(AnimationInDurationProperty); }
			set { SetValue(AnimationInDurationProperty, value); }
		}
        public static readonly DependencyProperty AnimationOutDurationProperty = DependencyProperty.Register("AnimationOutDuration", typeof(double), typeof(TabControlSweptAnimated), new PropertyMetadata(DefaultOutDuration));
        public double AnimationOutDuration
        {
            get { return (double)GetValue(AnimationOutDurationProperty); }
            set { SetValue(AnimationOutDurationProperty, value); }
        }

        public static readonly DependencyProperty AnimationDecelerationProperty = DependencyProperty.Register("AnimationDeceleration", typeof(double), typeof(TabControlSweptAnimated), new PropertyMetadata(0.9));
		public double AnimationDeceleration
		{
			get { return (double)GetValue(AnimationDecelerationProperty); }
			set { SetValue(AnimationDecelerationProperty, value); }
		}


		protected Storyboard sbOut;
		protected Storyboard sbIn;
		protected Panel content;
		protected SelectionChangedEventArgs eventE;
		protected bool midAnimation = false;
		protected Thickness oldMargin;

        private Panel ItemsHolderPanel = null;

        public TabControlSweptAnimated() : base()
		{
            ItemContainerGenerator.StatusChanged += ItemContainerGenerator_StatusChanged;
            sbOut = new Storyboard();
			sbIn = new Storyboard();
			sbOut.Completed += (s, e) =>
			{
				base.OnSelectionChanged(eventE);
                UpdateSelectedItem();
                sbIn.Begin(content);
			};
			sbIn.Completed += (s, e) =>
			{
				midAnimation = false;
				base.OnSelectionChanged(eventE);
                UpdateSelectedItem();
            };
		}

		protected override void OnSelectionChanged(SelectionChangedEventArgs e)
		{
            eventE = e;
            if (!midAnimation)
            {
            	oldMargin = content.Margin;
            	midAnimation = true;
            }
            else
            	return;
            
            var animOut = SweptAnimation.CreateAnim(
            	AnimationOutDuration,
            	new Thickness(oldMargin.Left, 0, oldMargin.Right, 0),
            	new Thickness(oldMargin.Left + content.ActualWidth, 0, oldMargin.Right - content.ActualWidth, 0), 
            	AnimationDeceleration
            );
            var animIn = SweptAnimation.CreateAnim(
            	AnimationInDuration,
            	new Thickness(oldMargin.Left - content.ActualWidth, 0, oldMargin.Right + content.ActualWidth, 0),
            	new Thickness(oldMargin.Left, 0, oldMargin.Right, 0),
            	AnimationDeceleration
            );
            
            sbOut.Children.Clear();
            sbIn.Children.Clear();
            sbOut.Children.Add(animOut);
            sbIn.Children.Add(animIn);
            
            sbOut.Begin(content);
        }

        /// <summary>
        /// If containers are done, generate the selected item
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ItemContainerGenerator_StatusChanged(object sender, EventArgs e)
        {
            if (this.ItemContainerGenerator.Status == GeneratorStatus.ContainersGenerated)
            {
                this.ItemContainerGenerator.StatusChanged -= ItemContainerGenerator_StatusChanged;
                UpdateSelectedItem();
            }
        }

        /// <summary>
        /// Get the ItemsHolder and generate any children
        /// </summary>
        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            ItemsHolderPanel = GetTemplateChild("PART_ItemsHolder") as Panel;
            content = ItemsHolderPanel;
            UpdateSelectedItem();
        }

        /// <summary>
        /// When the items change we remove any generated panel children and add any new ones as necessary
        /// </summary>
        /// <param name="e"></param>
        protected override void OnItemsChanged(NotifyCollectionChangedEventArgs e)
        {
            base.OnItemsChanged(e);

            if (ItemsHolderPanel == null)
                return;

            switch (e.Action)
            {
                case NotifyCollectionChangedAction.Reset:
                    ItemsHolderPanel.Children.Clear();
                    break;

                case NotifyCollectionChangedAction.Add:
                case NotifyCollectionChangedAction.Remove:
                    if (e.OldItems != null)
                    {
                        foreach (var item in e.OldItems)
                        {
                            ContentPresenter cp = FindChildContentPresenter(item);
                            if (cp != null)
                                ItemsHolderPanel.Children.Remove(cp);
                        }
                    }

                    // Don't do anything with new items because we don't want to
                    // create visuals that aren't being shown

                    UpdateSelectedItem();
                    break;

                case NotifyCollectionChangedAction.Replace:
                    throw new NotImplementedException("Replace not implemented yet");
            }
        }

        private void UpdateSelectedItem()
        {
            if (ItemsHolderPanel == null)
                return;

            // Generate a ContentPresenter if necessary
            TabItem item = GetSelectedTabItem();
            if (item != null)
                CreateChildContentPresenter(item);

            // show the right child
            foreach (ContentPresenter child in ItemsHolderPanel.Children)
                child.Visibility = ((child.Tag as TabItem).IsSelected) ? Visibility.Visible : Visibility.Collapsed;
        }

        private ContentPresenter CreateChildContentPresenter(object item)
        {
            if (item == null)
                return null;

            ContentPresenter cp = FindChildContentPresenter(item);

            if (cp != null)
                return cp;

            // the actual child to be added.  cp.Tag is a reference to the TabItem
            cp = new ContentPresenter();
            cp.Content = (item is TabItem) ? (item as TabItem).Content : item;
            cp.ContentTemplate = this.SelectedContentTemplate;
            cp.ContentTemplateSelector = this.SelectedContentTemplateSelector;
            cp.ContentStringFormat = this.SelectedContentStringFormat;
            cp.Visibility = Visibility.Collapsed;
            cp.Tag = (item is TabItem) ? item : (this.ItemContainerGenerator.ContainerFromItem(item));
            ItemsHolderPanel.Children.Add(cp);
            return cp;
        }

        private ContentPresenter FindChildContentPresenter(object data)
        {
            if (data is TabItem)
                data = (data as TabItem).Content;

            if (data == null)
                return null;

            if (ItemsHolderPanel == null)
                return null;

            foreach (ContentPresenter cp in ItemsHolderPanel.Children)
            {
                if (cp.Content == data)
                    return cp;
            }

            return null;
        }

        protected TabItem GetSelectedTabItem()
        {
            object selectedItem = base.SelectedItem;
            if (selectedItem == null)
                return null;

            TabItem item = selectedItem as TabItem;
            if (item == null)
                item = base.ItemContainerGenerator.ContainerFromIndex(base.SelectedIndex) as TabItem;

            return item;
        }
    }
}
