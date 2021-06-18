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
		public int Counter = 0;

		public ProfileDA()
		{
			ImageFolder = new DirectoryInfo(ImageFolderPath);
			if (ImageFolder.Exists)
			{
				var Files = new List<FileInfo>(ImageFolder.GetFiles());
				int currentCount;
				for (int i = 0; i < Files.Count; i++)
				{
					if (int.TryParse(Files[i].Name, out currentCount))
					{
						if (currentCount < 0)
							Files.RemoveAt(i);
						else if (currentCount > Counter)
							Counter = currentCount;
					}
					else
						Files.RemoveAt(i);
				}
			}
			else
			{
				Directory.CreateDirectory(ImageFolderPath);
			}
		}

		public string AddImage(string originalPath)
		{
			if (File.Exists(originalPath))
			{
				if (!SupportedImage.Contains(Path.GetExtension(originalPath)))
					return "";

				if (LoadImage(originalPath) is null)
					return "";

				FileInfo file = new FileInfo(originalPath);
				var abPath = Path.Combine(ImageFolderPath, Counter.ToString());

				var existingFile = new FileInfo(abPath);
				if (existingFile.Exists)
					existingFile.IsReadOnly = false;

				file.CopyTo(abPath, true);

				var copyFile = new FileInfo(abPath);
				Counter++;
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
					deleteFile.Delete();
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
