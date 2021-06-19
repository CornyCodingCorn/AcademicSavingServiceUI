using AcademicSavingService.Commands;
using AcademicSavingService.Controls;
using PropertyChanged;
using System.IO;
using System.Windows.Input;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AcademicSavingService.ViewModel
{
	[AddINotifyPropertyChangedInterface]
	class SettingsViewModel : MenuItemViewModel
	{
		public static readonly string SettingFilePath = "Setting.cum";

		public bool AskBeforeDelete 
		{ 
			get { return AssApp.AskBeforeDelete; }
			set { AssApp.AskBeforeDelete = value; }
		}
		public bool AskBeforeUpdate 
		{ 
			get { return AssApp.AskBeforeUpdate; }
			set { AssApp.AskBeforeUpdate = value; }
		}

		protected RelayCommand<string> _greenThemeCommand;
		public ICommand ChangeThemeCommand => _greenThemeCommand ?? (_greenThemeCommand = new RelayCommand<string>(param => ExecuteChangeTheme(param), param => CanExecuteChangeTheme()));

		protected readonly string _beforeDelete = @"AskBeforeDelete";
		protected readonly string _beforeUpdate = @"AskBeforeUpdate";
		protected readonly string _themeColor = @"ThemeColor";

		public SettingsViewModel(MainViewModel mainViewModel) : base(mainViewModel)
		{
			Load();
		}

		public override void Dispose()
		{
			JObject settings = new JObject();
			settings[_beforeDelete] = AskBeforeDelete;
			settings[_beforeUpdate] = AskBeforeUpdate;
			settings[_themeColor] = AssApp.ActiveThemeColor;


			if (File.Exists(SettingFilePath))
			{
				FileInfo fileInfo = new FileInfo(SettingFilePath);
				fileInfo.IsReadOnly = false;
			}
			else
			{
				var stream = File.CreateText(SettingFilePath);
				stream.Close();
			}
			File.WriteAllText(SettingFilePath, settings.ToString());
		}

		protected void Load()
		{
			if (!File.Exists(SettingFilePath))
				return;

			try
			{
				using (StreamReader reader = File.OpenText(SettingFilePath))
				{
					JObject settings = (JObject)JToken.ReadFrom(new JsonTextReader(reader));

					AskBeforeDelete = settings[_beforeDelete].Value<bool>();
					AskBeforeUpdate = settings[_beforeUpdate].Value<bool>();

					AssApp.ChangeTheme(settings[_themeColor].Value<string>());

					reader.Close();
				}
			}
			catch
			{
				MessageBox.ShowMessage("WARNING!", "Setting file is corrupted, all the setting will be reseted.");
				AskBeforeDelete = true;
				AskBeforeUpdate = true;
				AssApp.ChangeTheme("Cyan");
			}
		}

		protected void ExecuteChangeTheme(string theme)
		{
			AssApp.ChangeTheme(theme);
		}
		protected bool CanExecuteChangeTheme()
		{ 
			return true;
		}
	}
}
