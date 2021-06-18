using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.IO;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace AcademicSavingService.DataAccess
{
	class ProfileDA
	{
		public readonly string[] SupportedImage = new string[] {
			".png",
			".jpeg",
			".jpg",
			".jpe",
			".bmp",
			".gif"
		};

		public readonly string ImageFolderPath = @"Images/";
		public DirectoryInfo ImageFolder {get; private set; }

		public ProfileDA()
		{
			ImageFolder = new DirectoryInfo(ImageFolderPath);
			if (!ImageFolder.Exists)
			{
				Directory.CreateDirectory(ImageFolderPath);
			}
		}

		public string AddImage(string originalPath, int CustomerID)
		{
			if (File.Exists(originalPath))
			{
				if (!SupportedImage.Contains(Path.GetExtension(originalPath)))
					return "";

				if (LoadImage(originalPath) is null)
					return "";

				FileInfo file = new FileInfo(originalPath);
				var abPath = Path.Combine(ImageFolderPath, CustomerID.ToString());

				var existingFile = new FileInfo(abPath);
				if (existingFile.Exists)
					existingFile.IsReadOnly = false;

				file.CopyTo(abPath, true);

				var copyFile = new FileInfo(abPath);
				copyFile.IsReadOnly = true;

				return abPath;
			}
			return "";
		}

		public bool RemoveImage(string stringPath)
		{
			if (File.Exists(stringPath))
			{
				FileInfo deleteFile = new FileInfo(stringPath);
				if (deleteFile.Exists)
				{
					deleteFile.IsReadOnly = false;
					deleteFile.Delete();
				}
			}

			return false;
		}

		public ImageSource LoadImage(string path)
		{
			try
			{
				var image = File.ReadAllBytes(path);
				var source = new BitmapImage();

				source.BeginInit();
				source.StreamSource = new MemoryStream(image);
				source.EndInit();

				return source;
			}
			catch
			{
				return null;
			}
		}
	}
}
