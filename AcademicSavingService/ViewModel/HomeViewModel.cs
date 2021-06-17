
using System;
using System.Threading;
using System.Threading.Tasks;

namespace AcademicSavingService.ViewModel
{
	class HomeViewModel : MenuItemViewModel
	{
		public DateTime NOW { get; set; } = DateTime.Now;
		public double PAPAFRANKU { get; set; } = 0;
		protected CancellationTokenSource token;

		public HomeViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
			token = new CancellationTokenSource();
			Task.Run(() =>
			{
				while (!token.IsCancellationRequested)
				{
					if (NOW != DateTime.Now)
						NOW = DateTime.Now;
					if (NOW.Second == 59)
					{
						PAPAFRANKU = 1;
						Task.Delay(1000);
						PAPAFRANKU = 0;
					}
					Task.Delay(1000);
				}
			});
		}

		~HomeViewModel()
		{
			token.Cancel();
		}
	}
}
