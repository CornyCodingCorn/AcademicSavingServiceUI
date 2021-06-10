using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Animation;
using System.Windows;

namespace AcademicSavingService.Animation
{
	public class SweptAnimation
	{
		public enum Type
		{ 
			None,
			Left,
			Right,
			Up,
			Down
		}

		public static ThicknessAnimation CreateAnim(double duration, Thickness start, Thickness end, double deceleration)
		{
			var anim = new ThicknessAnimation
			{
				Duration = new Duration(TimeSpan.FromSeconds(duration)),
				From = new Thickness(start.Left, start.Top, start.Bottom, start.Right),
				To = new Thickness(end.Left, end.Top, end.Bottom, end.Right),
				DecelerationRatio = deceleration
			};
			Storyboard.SetTargetProperty(anim, new PropertyPath("Margin"));
			return anim;
		}
	}
}
