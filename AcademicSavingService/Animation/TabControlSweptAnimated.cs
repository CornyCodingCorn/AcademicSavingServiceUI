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

namespace AcademicSavingService.Animation
{
	public class TabControlSweptAnimated : TabControl
	{
		public static readonly DependencyProperty AnimationDurationProperty = DependencyProperty.Register("AnimationDuration", typeof(double), typeof(TabControlSweptAnimated), new PropertyMetadata(0.4));
		public double AnimationDuration
		{ 
			get { return (double)GetValue(AnimationDurationProperty); }
			set { SetValue(AnimationDurationProperty, value); }
		}

		public static readonly DependencyProperty AnimationDecelerationProperty = DependencyProperty.Register("AnimationDeceleration", typeof(double), typeof(TabControlSweptAnimated), new PropertyMetadata(0.9));
		public double AnimationDeceleration
		{
			get { return (double)GetValue(AnimationDecelerationProperty); }
			set { SetValue(AnimationDecelerationProperty, value); }
		}


		protected Storyboard sbOut;
		protected Storyboard sbIn;
		protected ContentPresenter content;
		protected SelectionChangedEventArgs eventE;
		protected bool midAnimation = false;
		protected Thickness oldMargin;

		public TabControlSweptAnimated()
		{
			sbOut = new Storyboard();
			sbIn = new Storyboard();
			sbOut.Completed += (s, e) =>
			{
				base.OnSelectionChanged(eventE);
				sbIn.Begin(content);
			};
			sbIn.Completed += (s, e) =>
			{
				midAnimation = false;
				base.OnSelectionChanged(eventE);
			};
		}

		protected override void OnSelectionChanged(SelectionChangedEventArgs e)
		{
			eventE = e;
			content = GetVisualChild<ContentPresenter>(this);
			if (!midAnimation)
			{
				oldMargin = content.Margin;
				midAnimation = true;
			}
			else
				return;

			var animOut = SweptAnimation.CreateAnim(
				AnimationDuration / 2,
				content.Margin,
				new Thickness(oldMargin.Left + content.ActualWidth, oldMargin.Top, oldMargin.Right - content.ActualWidth, oldMargin.Bottom), 
				AnimationDeceleration
			);;
			var animIn = SweptAnimation.CreateAnim(
				AnimationDuration / 2,
				new Thickness(oldMargin.Left - content.ActualWidth, oldMargin.Top, oldMargin.Right + content.ActualWidth, oldMargin.Bottom),
				content.Margin,
				AnimationDeceleration
			);
			
			sbOut.Children.Clear();
			sbIn.Children.Clear();
			sbOut.Children.Add(animOut);
			sbIn.Children.Add(animIn);

			sbOut.Begin(content);
		}

		private T GetVisualChild<T>(DependencyObject parent) where T : Visual
		{
			T child = default(T);
			int numVisuals = VisualTreeHelper.GetChildrenCount(parent);
			for (int i = 0; i < numVisuals; i++)
			{
				Visual v = (Visual)VisualTreeHelper.GetChild(parent, i);
				child = v as T;
				if (child == null)
				{
					child = GetVisualChild<T>(v);
				}
				if (child != null)
				{
					break;
				}
			}
			return child;
		}
	}
}
