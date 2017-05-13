namespace CSharpRuntimeCameo
{
	partial class MainWindow
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		/// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Windows Form Designer generated code

		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
            this.TextBoxUrl = new System.Windows.Forms.TextBox();
            this.ButtonConnect = new System.Windows.Forms.Button();
            this.PanelCameo = new System.Windows.Forms.Panel();
            this.ComboBoxProgID = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // TextBoxUrl
            // 
            this.TextBoxUrl.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.TextBoxUrl.Location = new System.Drawing.Point(12, 12);
            this.TextBoxUrl.Name = "TextBoxUrl";
            this.TextBoxUrl.Size = new System.Drawing.Size(457, 20);
            this.TextBoxUrl.TabIndex = 0;
            this.TextBoxUrl.TextChanged += new System.EventHandler(this.TextBoxUrl_TextChanged);
            this.TextBoxUrl.KeyDown += new System.Windows.Forms.KeyEventHandler(this.TextBoxUrl_KeyDown);
            // 
            // ButtonConnect
            // 
            this.ButtonConnect.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ButtonConnect.Location = new System.Drawing.Point(642, 10);
            this.ButtonConnect.Name = "ButtonConnect";
            this.ButtonConnect.Size = new System.Drawing.Size(75, 23);
            this.ButtonConnect.TabIndex = 1;
            this.ButtonConnect.Text = "Connect";
            this.ButtonConnect.UseVisualStyleBackColor = true;
            this.ButtonConnect.Click += new System.EventHandler(this.ButtonConnect_Click);
            // 
            // PanelCameo
            // 
            this.PanelCameo.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.PanelCameo.Location = new System.Drawing.Point(12, 41);
            this.PanelCameo.Name = "PanelCameo";
            this.PanelCameo.Size = new System.Drawing.Size(704, 576);
            this.PanelCameo.TabIndex = 2;
            // 
            // ComboBoxProgID
            // 
            this.ComboBoxProgID.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ComboBoxProgID.FormattingEnabled = true;
            this.ComboBoxProgID.Items.AddRange(new object[] {
            "GCA.VIP.DeviceProxy",
            "GCA.ONVIF.DeviceProxy",
            "GCA.RTSP.DeviceProxy",
			"GCA.File.DeviceProxy",
            "GCA.Divar600.DeviceProxy",
            "GCA.Divar700.DeviceProxy",
            "GCA.DiBos.DeviceProxy"});
            this.ComboBoxProgID.Location = new System.Drawing.Point(486, 12);
            this.ComboBoxProgID.Name = "ComboBoxProgID";
            this.ComboBoxProgID.Size = new System.Drawing.Size(150, 21);
            this.ComboBoxProgID.TabIndex = 3;
            // 
            // MainWindow
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(729, 627);
            this.Controls.Add(this.ComboBoxProgID);
            this.Controls.Add(this.PanelCameo);
            this.Controls.Add(this.ButtonConnect);
            this.Controls.Add(this.TextBoxUrl);
            this.Name = "MainWindow";
            this.Text = "Runtime Cameo Sample";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainWindow_FormClosing);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainWindow_FormClosed);
            this.Load += new System.EventHandler(this.MainWindow_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		#endregion

		private System.Windows.Forms.TextBox TextBoxUrl;
		private System.Windows.Forms.Button ButtonConnect;
		private System.Windows.Forms.Panel PanelCameo;
        private System.Windows.Forms.ComboBox ComboBoxProgID;
	}
}

