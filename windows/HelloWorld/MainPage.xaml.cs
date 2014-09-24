/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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
            PushConfig pushConfig = new PushConfig() { UnifiedPushUri = new Uri("http://localhost:8080/ag-push/"), VariantId = "18e83a14-e235-489a-b06e-ff7957e13210", VariantSecret = "dd0e98b2-8b98-4778-a640-fdafb8901768" };
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
