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
using System.Collections.ObjectModel;
using System.ComponentModel;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;
using Windows.UI.Xaml.Navigation;

// The Blank Page item template is documented at http://go.microsoft.com/fwlink/?LinkId=391641

namespace HelloWorld
{
    /// <summary>
    /// An empty page that can be used on its own or navigated to within a Frame.
    /// </summary>
    public sealed partial class MainPage : Page, INotifyPropertyChanged
    {
        public ObservableCollection<string> messageList { get; private set; }
        public string bellSlash
        {
            get { return "\uf1f6"; }
        }
        public event PropertyChangedEventHandler PropertyChanged;
        public UiState registerState { get; set; }

        public MainPage()
        {
            this.InitializeComponent();

            messageList = new ObservableCollection<string>();
            registerState = new UiState();
            DataContext = this;

            this.NavigationCacheMode = NavigationCacheMode.Required;
        }

        void onRegistrationComplete()
        {
            registerState.RegistrationDone();
            PropertyChanged(this, new PropertyChangedEventArgs("registerState"));
        }

        async void HandleNotification(object sender, PushReceivedEvent e)
        {
            await Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
            {
                registerState.HasContent();
                PropertyChanged(this, new PropertyChangedEventArgs("registerState"));
                messageList.Add(e.Args.message);
            });

        }

        /// <summary>
        /// Invoked when this page is about to be displayed in a Frame.
        /// </summary>
        /// <param name="e">Event data that describes how this page was reached.
        /// This parameter is typically used to configure the page.</param>
        protected async override void OnNavigatedTo(NavigationEventArgs e)
        {
            // TODO: Prepare page for display here.

            // TODO: If your application contains multiple pages, ensure that you are
            // handling the hardware Back button by registering for the
            // Windows.Phone.UI.Input.HardwareButtons.BackPressed event.
            // If you are using the NavigationHelper provided by some templates,
            // this event is handled for you.

            PushConfig pushConfig = new PushConfig() { UnifiedPushUri = new Uri("https://unifiedpush-edewit.rhcloud.com/ag-push/"), VariantId = "c93fa2a7-70bb-4d34-a308-e0c0a688e6aa", VariantSecret = "fad4c664-1dd3-480a-b966-2a7e9c826af1" };
            Registration registration = new WnsRegistration();
            registration.PushReceivedEvent += HandleNotification;
            try
            {
                await registration.Register(pushConfig);
                onRegistrationComplete();
            }
            catch (Exception ex)
            {
                new MessageDialog("Error", ex.Message).ShowAsync();
            }

            this.InitializeComponent();
        }
    }

    public class UiState
    {
        public enum State { Register, Empty, List }
        private State state = State.Register;

        public Visibility isRegistering
        {
            get { return state == State.Register ? Visibility.Visible : Visibility.Collapsed; }
        }

        public Visibility isNotRegistering
        {
            get { return state != State.Register ? Visibility.Visible : Visibility.Collapsed; }
        }

        public Visibility noContent
        {
            get { return state == State.Empty ? Visibility.Visible : Visibility.Collapsed; }
        }

        public void RegistrationDone()
        {
            state = State.Empty;
        }

        public void HasContent()
        {
            state = State.List;
        }
    }
}
