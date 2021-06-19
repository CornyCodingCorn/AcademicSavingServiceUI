
using System;
using System.Threading;
using System.Threading.Tasks;

namespace AcademicSavingService.ViewModel
{
	class HomeViewModel : MenuItemViewModel
	{
		public DateTime NOW { get; set; } = DateTime.Now;
		public double PAPAFRANKU { get; set; } = 0;
		public int MinutePerFRANKU { get ; set; } = 69;

		protected CancellationTokenSource token;

		public HomeViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
			token = new CancellationTokenSource();
			Task.Run(async () =>
			{
				int minutePassed = 0;
				while (!token.IsCancellationRequested)
				{
					if (NOW != DateTime.Now)
						NOW = DateTime.Now;
					if (NOW.Second == 59)
					{
						minutePassed++;
						if (minutePassed == MinutePerFRANKU)
						{
							while (PAPAFRANKU < 1)
							{
								PAPAFRANKU += 0.01;
								await Task.Delay(10);
							}
							PAPAFRANKU = 1;
							int seizureCounter = 0;
							while (seizureCounter < 100)
							{
								PAPAFRANKU = seizureCounter % 2;
								await Task.Delay(10);
								seizureCounter++;
							}
							PAPAFRANKU = 1;
							while (PAPAFRANKU > 0)
							{
								PAPAFRANKU -= 0.01;
								await Task.Delay(10);
							}
							PAPAFRANKU = 0;
							minutePassed = 0;
						}
					}
					await Task.Delay(1000);
				}
			});
		}

		public override void Dispose()
		{
			token.Cancel();
			base.Dispose();
		}
	}
}
