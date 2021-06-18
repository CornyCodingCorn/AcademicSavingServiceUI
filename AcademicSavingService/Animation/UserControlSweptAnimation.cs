using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Animation;

namespace AcademicSavingService.Animation
{
    public class UserControlSweptAnimation : UserControl
    {
        public static double DefaultInDuration { get; } = 0.6;
        public static double DefaultOutDuration { get; } = 0.3;

        public static readonly DependencyProperty AnimationInDurationProperty = DependencyProperty.Register("AnimationInDuration", typeof(double), typeof(UserControlSweptAnimation), new PropertyMetadata(DefaultInDuration));
        public double AnimationInDuration
        {
            get { return (double)GetValue(AnimationInDurationProperty); }
            set { SetValue(AnimationInDurationProperty, value); }
        }
        public static readonly DependencyProperty AnimationOutDurationProperty = DependencyProperty.Register("AnimationOutDuration", typeof(double), typeof(UserControlSweptAnimation), new PropertyMetadata(DefaultOutDuration));
        public double AnimationOutDuration
        {
            get { return (double)GetValue(AnimationOutDurationProperty); }
            set { SetValue(AnimationOutDurationProperty, value); }
        }

        public static readonly DependencyProperty AnimationDecelerationProperty = DependencyProperty.Register("AnimationDeceleration", typeof(double), typeof(UserControlSweptAnimation), new PropertyMetadata(0.9));
        public double AnimationDeceleration
        {
            get { return (double)GetValue(AnimationDecelerationProperty); }
            set { SetValue(AnimationDecelerationProperty, value); }
        }

        public static readonly DependencyProperty AnimVisibilityProperty = DependencyProperty.Register("AnimVisibility", typeof(bool), typeof(UserControlSweptAnimation), new PropertyMetadata(true, new PropertyChangedCallback(OnAnimVisibilityPropertyChanged)));
        public bool AnimVisibility
		{ 
            get { return (bool)GetValue(AnimVisibilityProperty); }
            set { SetValue(AnimVisibilityProperty, value); }
        }

        protected Storyboard sbOut;
        protected Storyboard sbIn;
        protected Panel content;
        protected SelectionChangedEventArgs eventE;
        protected bool midAnimation = false;

        protected Thickness oldMargin;
        protected double oldActualWidth;
        protected double oldActualHeight;

        public event EventHandler OutAnimComplete;
        public event EventHandler InAnimComplete;

        public UserControlSweptAnimation() : base()
        {
            sbOut = new Storyboard();
            sbIn = new Storyboard();

            sbOut.Completed += (s, e) =>
            {
                Visibility = Visibility.Hidden;
                OutAnimComplete?.Invoke(this, new EventArgs());
                midAnimation = false;
                if (AnimVisibility)
                    Visibility = Visibility.Visible;
            };
            sbIn.Completed += (s, e) =>
            {
                InAnimComplete?.Invoke(this, new EventArgs());
                midAnimation = false;
                if (!AnimVisibility)
                    Visibility = Visibility.Hidden;
            };
        }

        private static void OnAnimVisibilityPropertyChanged(DependencyObject sender, DependencyPropertyChangedEventArgs e)
        {
            if (e.OldValue == e.NewValue) 
                return;

            UserControlSweptAnimation control = (UserControlSweptAnimation)sender;
            if (control != null)
            {
               control.OnAnimVisibilityChanged((bool)e.NewValue);
            }
        }

        protected virtual void OnAnimVisibilityChanged(bool visibility)
		{
            if (visibility)
			{
                if (midAnimation)
                    return;

                midAnimation = true;

                var animIn = SweptAnimation.CreateAnim(
                    AnimationInDuration,
                    new Thickness(oldMargin.Left - oldActualWidth, 0, oldMargin.Right + oldActualWidth, 0),
                    new Thickness(oldMargin.Left, 0, oldMargin.Right, 0),
                    AnimationDeceleration
                );
                sbIn.Children.Clear();
                sbIn.Children.Add(animIn);

                Visibility = Visibility.Visible;

                sbIn.Begin(this);
			}
            else
            {
                if (midAnimation)
                    return;

                oldMargin = Margin;
                oldActualHeight = ActualHeight;
                oldActualWidth = ActualWidth;
                midAnimation = true;

                var animOut = SweptAnimation.CreateAnim(
                    AnimationOutDuration,
                    new Thickness(oldMargin.Left, 0, oldMargin.Right, 0),
                    new Thickness(oldMargin.Left + ActualWidth, 0, oldMargin.Right - ActualWidth, 0),
                    AnimationDeceleration
                );
                sbOut.Children.Clear();
                sbOut.Children.Add(animOut);

                sbOut.Begin(this);
            }
		}
    }
}
