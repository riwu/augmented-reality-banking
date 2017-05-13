using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Bosch.VideoSDK.AxCameoLib;
using Bosch.VideoSDK.CameoLib;
using Bosch.VideoSDK.Device;
using Bosch.VideoSDK.GCALib;
using Bosch.VideoSDK.Live;

namespace CSharpRuntimeCameo
{
	public partial class MainWindow : Form
	{
		private enum HRESULT : uint
		{
			S_OK = 0,
			E_FAIL = 0x80004005,
			E_UNEXPECTED = 0x8000FFFF,
			E_NOTIMPL = 0x80004001,
			E_INVALIDARG = 0x80070057,
			IgnoreAndFixLater = 0xFFFFFFFF
		};

		private enum State
		{
			Disconnected,
			Connecting,
			Connected,
			Disconnecting
		}

		public MainWindow()
		{
			InitializeComponent();
		}
		private State m_state = State.Disconnected;
		private Bosch.VideoSDK.Device.DeviceConnector m_deviceConnector = new Bosch.VideoSDK.Device.DeviceConnectorClass();
		private Bosch.VideoSDK.Device.DeviceProxy m_deviceProxy = null;
		Bosch.VideoSDK.AxCameoLib.AxCameo m_axCameo = null;
		private Bosch.VideoSDK.CameoLib.Cameo m_cameo = null;
        private Bosch.VideoSDK.GCALib._IVideoInputVCAEvents_Event m_videoInputVCAEvents;

		private void MainWindow_Load(object sender, EventArgs e)
		{
			m_axCameo = new Bosch.VideoSDK.AxCameoLib.AxCameo();
			PanelCameo.Controls.Add(m_axCameo);
			m_axCameo.Dock = DockStyle.Fill;
			m_cameo = (Bosch.VideoSDK.CameoLib.Cameo)m_axCameo.GetOcx();
			
			m_deviceConnector.ConnectResult += new Bosch.VideoSDK.GCALib._IDeviceConnectorEvents_ConnectResultEventHandler(DeviceConnector_ConnectResult);
			ComboBoxProgID.SelectedIndex = 0;
			UpdateGUI();
		}

		private void MainWindow_FormClosing(object sender, FormClosingEventArgs e)
		{
			if ((m_state == State.Connecting) || (m_state == State.Disconnecting))
				e.Cancel = true;
		}

		private void MainWindow_FormClosed(object sender, FormClosedEventArgs e)
		{
			m_deviceConnector.ConnectResult -= new Bosch.VideoSDK.GCALib._IDeviceConnectorEvents_ConnectResultEventHandler(DeviceConnector_ConnectResult);
			if (m_state == State.Connected)
			{
				m_deviceProxy.ConnectionStateChanged -= new Bosch.VideoSDK.GCALib._IDeviceProxyEvents_ConnectionStateChangedEventHandler(DeviceProxy_ConnectionStateChanged);
				m_deviceProxy.Disconnect();
			}
			m_axCameo.Dispose();
		}

		private void ButtonConnect_Click(object sender, EventArgs e)
		{
			if (m_state == State.Disconnected)
			{
				try
				{
					m_state = State.Connecting;
					m_deviceConnector.ConnectAsync(TextBoxUrl.Text, ComboBoxProgID.Text);
				}
				catch (Exception ex)
				{
					if (HRESULT.IgnoreAndFixLater != CheckException(ex, "Failed to start asynchronous connection attempt to \"{0}\"", TextBoxUrl.Text))
						MessageBox.Show("Invalid IP address or progID! \n\nIP address:  " + TextBoxUrl.Text + "\nProgID:\t  " + ComboBoxProgID.Text, "Invalid Argument");
					
					m_state = State.Disconnected;
				}
			}
			else if (m_state == State.Connected)
			{
				m_state = State.Disconnecting;
				m_deviceProxy.Disconnect();
			}

			UpdateGUI();
		}

		private void DeviceConnector_ConnectResult(Bosch.VideoSDK.Device.ConnectResultEnum connectResult, string url, Bosch.VideoSDK.Device.DeviceProxy deviceProxy)
		{
			bool success = false;

			if (connectResult == Bosch.VideoSDK.Device.ConnectResultEnum.creInitialized)
			{
				if (deviceProxy.VideoInputs.Count > 0)
				{
					success = true;

					try
					{
						m_cameo.SetVideoStream(deviceProxy.VideoInputs[1].Stream);
                        this.m_videoInputVCAEvents = deviceProxy.VideoInputs[(object)1] as Bosch.VideoSDK.GCALib._IVideoInputVCAEvents_Event;
                        m_axCameo.VcaConfig.DisplayMode = Bosch.VideoSDK.Live.VcaDisplayModes.vcmRenderVCD;

                        if (this.m_videoInputVCAEvents != null)
                        {
                            
                            // ISSUE: method pointer
                            m_videoInputVCAEvents.MotionDetectorsStateChanged += new Bosch.VideoSDK.GCALib._IVideoInputVCAEvents_MotionDetectorsStateChangedEventHandler(VideoInputVCAEvents_MotionDetectorsStateChanged);
                            //this.m_videoInputVCAEvents.add_MotionDetectorsStateChanged(new _IVideoInputVCAEvents_MotionDetectorsStateChangedEventHandler((object) this, (UIntPtr) __methodptr(VideoInputVCAEvents_MotionDetectorsStateChanged)));
                        }
                        

                        
					}
					catch (Exception ex)
					{
						CheckException(ex, "Failed to render first video stream of {0}", url);
						success = false;
					}
				}
			}

			if (success)
			{
				m_deviceProxy = deviceProxy;
				m_deviceProxy.ConnectionStateChanged += new Bosch.VideoSDK.GCALib._IDeviceProxyEvents_ConnectionStateChangedEventHandler(DeviceProxy_ConnectionStateChanged);
				m_state = State.Connected;
			}
			else
			{
				if (deviceProxy != null)
					deviceProxy.Disconnect();
				m_state = State.Disconnected;
				MessageBox.Show("Failed to connect to \"" + url + "\".");
			}

			UpdateGUI();
		}

        private void VideoInputVCAEvents_MotionDetectorsStateChanged(Bosch.VideoSDK.Live.VideoInput pEventSource, int ConfigId, int DetectorsState)
        {
            if((DetectorsState & 0x01) == 0x01)
            {
                /*This is where Rule 1 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 1 activated");
                /*End rule 1*/
            }
            if ((DetectorsState & 0x02) == 0x02)
            {
                /*This is where Rule 2 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 2 activated");
                /*End rule 2*/
            }
            if ((DetectorsState & 0x04) == 0x04)
            {
                /*This is where Rule 3 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 3 activated");
                /*End rule 3*/
            }
            if ((DetectorsState & 0x08) == 0x08)
            {
                /*This is where Rule 4 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 4 activated");
                /*End rule 4*/
            }
            if ((DetectorsState & 0x10) == 0x10)
            {
                /*This is where Rule 5 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 5 activated");
                /*End rule 5*/
            }
            if ((DetectorsState & 0x20) == 0x20)
            {
                /*This is where Rule 6 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 6 activated");
                /*End rule 6*/
            }
            if ((DetectorsState & 0x40) == 0x40)
            {
                /*This is where Rule 7 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 7 activated");
                /*End rule 7*/
            }
            if ((DetectorsState & 0x80) == 0x80)
            {
                /*This is where Rule 8 is activated, please  fill in this section*/
                System.Diagnostics.Debug.WriteLine("Rule 8 activated");
                /*End rule 8*/
            }
        }

		private void DeviceProxy_ConnectionStateChanged(object eventSource, Bosch.VideoSDK.Device.ConnectResultEnum state)
		{
			if (state == Bosch.VideoSDK.Device.ConnectResultEnum.creConnectionTerminated)
			{
				m_cameo.SetVideoStream(null);
				m_deviceProxy.ConnectionStateChanged -= new Bosch.VideoSDK.GCALib._IDeviceProxyEvents_ConnectionStateChangedEventHandler(DeviceProxy_ConnectionStateChanged);
				m_deviceProxy = null;
				m_state = State.Disconnected;

				UpdateGUI();
			}
		}

		private void TextBoxUrl_KeyDown(object sender, KeyEventArgs e)
		{
			if (((e.KeyCode == Keys.Return) || (e.KeyCode == Keys.Enter)) && ButtonConnect.Enabled)
				ButtonConnect_Click(this, EventArgs.Empty);
		}

		private void TextBoxUrl_TextChanged(object sender, EventArgs e)
		{
			UpdateGUI();
		}

		private void UpdateGUI()
		{
			if (m_state == State.Disconnected)
			{
				ButtonConnect.Text = "Connect";
				ButtonConnect.Enabled = (TextBoxUrl.Text.Length > 0);
			}
			else if (m_state == State.Connecting)
			{
				ButtonConnect.Text = "Connecting";
				ButtonConnect.Enabled = false;
			}
			else if (m_state == State.Connected)
			{
				ButtonConnect.Text = "Disconnect";
				ButtonConnect.Enabled = true;
			}
			else // if (m_state == State.Disconnecting)
			{
				ButtonConnect.Text = "Disconnecting";
				ButtonConnect.Enabled = false;
			}
		}

		private HRESULT CheckException(Exception ex, string format, params object[] args)
		{
			string message = string.Format(format, args) + ": " + ex.Message;
			if (ex.GetType() == typeof(System.Runtime.InteropServices.COMException))
			{
				uint errorCode = (uint)((System.Runtime.InteropServices.COMException)ex).ErrorCode;
				if (errorCode == (uint)HRESULT.E_FAIL)
					return HRESULT.E_FAIL;
				else if (errorCode == (uint)HRESULT.E_UNEXPECTED)
					return HRESULT.E_UNEXPECTED;
			}
			else if (ex.GetType() == typeof(System.NotImplementedException))
				return HRESULT.E_NOTIMPL;
			else if (ex.GetType() == typeof(System.ArgumentException))
				return HRESULT.E_INVALIDARG;

			if (MessageBox.Show(message + "\n\nTerminate application?", "Unexpected Exception", MessageBoxButtons.YesNo, MessageBoxIcon.Error) == DialogResult.Yes)
			{
				System.Diagnostics.Process.GetCurrentProcess().Kill();
				throw ex;
			}
			else
				return HRESULT.IgnoreAndFixLater;
		}
	}
}
