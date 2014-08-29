using AeroGear.Push;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Threading.Tasks;
using Windows.Data.Xml.Dom;
using Windows.Networking.PushNotifications;
using Windows.UI.Core;
using Windows.UI.Notifications;
using Windows.UI.Popups;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=391641

namespace HelloWorld
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page
    {
        public ObservableCollection<string> messageList { get; private set; }
        public MainPage()
        {
            PushConfig pushConfig = new PushConfig() { UnifiedPushUri = new Uri("http://localhost:8080/ag-push/"), VariantId = "0f1a1dc8-4544-479f-8c86-d52483fa5621", VariantSecret = "14c07d0b-dbd0-41e4-a9a6-2ff5e4ee9804" };
            Registration registration = new Registration();
            registration.PushReceivedEvent += HandleNotification;
            registration.Register(pushConfig);
            onRegistrationComplete();

            this.InitializeComponent();

            messageList = new ObservableCollection<string>();
            DataContext = this;

            this.NavigationCacheMode = NavigationCacheMode.Required;
        }

        void onRegistrationComplete()
        {
            XmlDocument template = ToastNotificationManager.GetTemplateContent(ToastTemplateType.ToastText01);
            IXmlNode notification = template.GetElementsByTagName("text").Item(0);
            notification.AppendChild(template.CreateTextNode("registration complete"));
            ToastNotificationManager.CreateToastNotifier().Show(new ToastNotification(template));
        }

        void HandleNotification(object sender, PushReceivedEvent e)
        {
            Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () => messageList.Add(e.Args.ToastNotification.Content.InnerText));
        }

        /// <summary>
        /// Invoked when this page is about to be displayed in a Frame.
        /// </summary>
        /// <param name="e">Event data that describes how this page was reached.
        /// This parameter is typically used to configure the page.</param>
        protected override void OnNavigatedTo(NavigationEventArgs e)
        {
            // TODO: Prepare page for display here.

            // TODO: If your application contains multiple pages, ensure that you are
            // handling the hardware Back button by registering for the
            // Windows.Phone.UI.Input.HardwareButtons.BackPressed event.
            // If you are using the NavigationHelper provided by some templates,
            // this event is handled for you.

        }
    }
}
