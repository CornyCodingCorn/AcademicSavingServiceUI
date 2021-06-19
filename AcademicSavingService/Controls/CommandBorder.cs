using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace AcademicSavingService.Controls
{
	public class CommandBorder : Border
	{
		public static readonly DependencyProperty CommandProperty = 
			DependencyProperty.Register("Command", typeof(ICommand), typeof(CommandBorder));
		public object Command
		{ 
			get { return GetValue(CommandProperty); }
			set { SetValue(CommandProperty, value); }
		}

		public object CommandParameter { get; set; }

		protected bool _isMouseDown = false;
		public event MouseButtonEventHandler OnClicked;

		protected override void OnMouseLeftButtonDown(MouseButtonEventArgs e)
		{
			if (!_isMouseDown)
			{
				((ICommand)Command).Execute(CommandParameter);
				_isMouseDown = true;
				OnClick(e);
			}
			base.OnMouseLeftButtonDown(e);
		}

		protected override void OnMouseLeftButtonUp(MouseButtonEventArgs e)
		{
			_isMouseDown = false;
			base.OnMouseLeftButtonUp(e);
		}

		protected virtual void OnClick(MouseButtonEventArgs e)
		{
			OnClicked?.Invoke(this, e);
		}
	}
}
