Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Envanter Aracı"
$form.Size = New-Object System.Drawing.Size(870, 1100)
$form.StartPosition = "CenterScreen"
$form.BackColor = "blue"

$logoImage = "dosya\mars.jpg"  # Logo dosyasının dosya yolu
$logoPictureBox = New-Object System.Windows.Forms.PictureBox
$logoPictureBox.Location = New-Object System.Drawing.Point(350, 0)
$logoPictureBox.Size = New-Object System.Drawing.Size(150, 150)  # 
$logoPictureBox.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom  
$logoPictureBox.Image = [System.Drawing.Image]::FromFile($logoImage)

$label2 = New-Object System.Windows.Forms.Label
$label2.Size = New-Object System.Drawing.Size(300, 50)
$label2.Location = New-Object System.Drawing.Point(325,150)
$label2.Text = "M.A.R.S Technology"
$label2.Font = New-Object System.Drawing.Font($label2.Font, [System.Drawing.FontStyle]::Bold)
$label2.Font = New-Object System.Drawing.Font("Courier New", 15)
$label2.ForeColor="white"

$label = New-Object System.Windows.Forms.Label
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$label.Size = New-Object System.Drawing.Size(700, 45)
$label.Location = New-Object System.Drawing.Point(75, 200)
$label.Text = "Bilgilerine erişmek istediğiniz cihazın `r`n IP adresini giriniz"
$label.Font = New-Object System.Drawing.Font("Courier New", 13)
$label.ForeColor="white"
$label2.Font = New-Object System.Drawing.Font($label.Font, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($label)

$label2 = New-Object System.Windows.Forms.Label
$label2.Size = New-Object System.Drawing.Size(300, 50)
$label2.Location = New-Object System.Drawing.Point(325,150)
$label2.Text = "M.A.R.S Technology"
$label2.Font = New-Object System.Drawing.Font($label2.Font, [System.Drawing.FontStyle]::Bold)
$label2.Font = New-Object System.Drawing.Font("Courier New", 15)
$label2.ForeColor="white"

$label = New-Object System.Windows.Forms.Label
$label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$label.Size = New-Object System.Drawing.Size(700, 45)
$label.Location = New-Object System.Drawing.Point(75, 200)
$label.Text = "Bilgilerine erişmek istediğiniz cihazın `r`n IP adresini giriniz"
$label.Font = New-Object System.Drawing.Font("Courier New", 13)
$label.ForeColor="white"
$label2.Font = New-Object System.Drawing.Font($label.Font, [System.Drawing.FontStyle]::Bold)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(300, 260)
$textBox.Size = New-Object System.Drawing.Size(250, 50)
$textBox.Font = New-Object System.Drawing.Font($textBox.Font, [System.Drawing.FontStyle]::Bold)
$textBox.ForeColor="black"
$textBox.Font = New-Object System.Drawing.Font("Courier New", 14)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(350, 315)
$button.Size = New-Object System.Drawing.Size(150, 65)
$button.Font = New-Object System.Drawing.Font("Courier New", 13)
$button.Padding = New-Object System.Windows.Forms.Padding(5)
$button.ForeColor="blue"
$button.BackColor = "white"
$button.BorderStyle = 'Fixed3D'
$button.BorderColor = 'white'
$button.BorderWidth = '2'
$button.Text = "Bilgileri Getir"

$infoTextBox = New-Object System.Windows.Forms.TextBox
$infoTextBox.Location = New-Object System.Drawing.Point(25, 400)
$infoTextBox.Size = New-Object System.Drawing.Size(800, 630)
$infoTextBox.Multiline = $true
$infoTextBox.ReadOnly = $true
$infoTextBox.BackColor = "blue"
$infoTextBox.ForeColor = "white"
$infoTextBox.BorderStyle = 'Fixed3D'
$infoTextBox.BorderColor = 'white'
$infoTextBox.BorderWidth = '2'
$infoTextBox.Font = New-Object System.Drawing.Font("Courier New", 15)

$form.Controls.Add($logoPictureBox)
$form.Controls.Add($label2)
$form.Controls.Add($label)
$form.Controls.Add($textBox)
$form.Controls.Add($button)
$form.Controls.Add($infoTextBox)

$form.AcceptButton = $button

$form.Add_KeyDown({
    if ($_.KeyCode -eq "Enter") {
        $button.PerformClick()
    }
})


$button.Add_Click({
 $ipAddress = $textBox.Text
 $output1 = ""
 $pingReply = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet

 if ([System.Net.IPAddress]::TryParse($ipAddress, [ref]$null)) {
 if ($pingReply) {
 $Info = Get-WmiObject -Query "select * from Win32_ComputerSystemProduct" -ComputerName $IpAddress
 $OperatingSystem = Get-WmiObject -Query "select * from Win32_OperatingSystem" -ComputerName $IpAddress
 $Ram = Get-WmiObject CIM_PhysicalMemory -ComputerName $IpAddress | Select-Object Manufacturer, ConfiguredClockSpeed, @{Name="Capacity"; Expression={$_.Capacity/1GB}}
 $Gpu = Get-WmiObject Win32_VideoController -ComputerName $IpAddress
 $Disk = Get-WmiObject Win32_DiskDrive -ComputerName $IpAddress | Select-Object Model, @{Name="Size"; Expression={"{0:N0}" -f ($_.Size/1GB)}}
 $Processor = Get-WmiObject -Query "SELECT * FROM Win32_Processor" -ComputerName $IpAddress
 $loggedOnUser = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName $IpAddress | Select-Object -ExpandProperty UserName).Split(’\’)[-1]
 $User = Get-ADUser -Identity $loggedOnUser -Properties SamAccountName,EmailAddress, Name, Title, Company, Department |
 select SamAccountName,EmailAddress, Name, Title, Company, Department

 if($OperatingSystem.Version -like "10.0.2*"){

 $OperatingSystem.Version = "Windows 11"
 }
 if($OperatingSystem.Version -like "10.0.1*"){
 $OperatingSystem.Version = "Windows 10"
 }
 if($OperatingSystem.Version -like "6.2*" -or $OperatingSystem.Version -like "6.3*" ){
 $OperatingSystem.Version = "Windows 8"
 }
 if($OperatingSystem.Version -like "6.1*"){
 $OperatingSystem.Version = "Windows 7"
 }

 $output1 = [ordered]@{
 "*" = "Kullanıcı Bilgileri *`r`n"
 "Logged on User" = "$($User.Name)"
 "Mail Adresi" = "$($User.EmailAddress)"
 "Kullanıcı Adı" = "$($User.SamAccountName)"
 "Title " = "$($User.title)" 
 "Departman" = "$($User.Department)"
 "Company" = "$($User.company) `r`n `r`n"

 "**" = "Cihaz Bilgileri **`r`n "

 "Computer Name " = "$($Info.PSComputerName) | Ip Address $IpAddress"
 "Model " = $Info.Name
 "Serial Number " = $Info.IdentifyingNumber
 "Processor " = $Processor.Name
 "Disk Model " = "$($Disk.Model) | Capacity $($Disk.Size) GB"
 "RAM Manufacturer " = "$($Ram.Manufacturer) | Capacity $($Ram.Capacity) GB | ClockSpeed $($Ram.ConfiguredClockSpeed) Mhz"
 "GPU " = $GPU.Name
 "Operating System " = $OperatingSystem.Version}

 $infoTextBox.Text = ""
 foreach ($key in $output1.Keys) {
 $infoTextBox.AppendText("${key}: $($output1[$key])`r`n")
 }
 } else {
 $infoTextBox.Text = "Cihazla bağlantı kurulamadı."
 }
 } else {
 $infoTextBox.Text = "Geçersiz IP adresi."
 }
})

$form.ShowDialog()
