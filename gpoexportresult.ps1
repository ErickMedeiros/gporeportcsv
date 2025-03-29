Import-Module GroupPolicy

# Lista todas as GPOs
$gpos = Get-GPO -All

# Array final
$result = @()

foreach ($gpo in $gpos) {
    # Relatório XML detalhado
    $settings = Get-GPOReport -Guid $gpo.Id -ReportType Xml
    $xml = [xml]$settings

    # User/Computer Status
    $userEnabled = if ($xml.GPO.User.Enabled -eq "true") { "Enabled" } else { "Disabled" }
    $computerEnabled = if ($xml.GPO.Computer.Enabled -eq "true") { "Enabled" } else { "Disabled" }

    # WMI Filter
    $wmiFilter = $null
    if ($xml.GPO.WmiFilter.Name) { $wmiFilter = $xml.GPO.WmiFilter.Name }

    # Linked OUs
    $linkedOUs = @()
    $enforcedLinks = @()

    # Percorre todas as OUs do domínio para ver se esta GPO está linkada
    $allContainers = Get-ADOrganizationalUnit -Filter * | Select-Object DistinguishedName
    foreach ($ou in $allContainers) {
        $inheritance = Get-GPInheritance -Target $ou.DistinguishedName
        foreach ($link in $inheritance.GpoLinks) {
            if ($link.DisplayName -eq $gpo.DisplayName) {
                $linkedOUs += $ou.DistinguishedName
                if ($link.Enforced) { $enforcedLinks += $ou.DistinguishedName }
            }
        }
    }
    $linkedOUs = if ($linkedOUs.Count -gt 0) { $linkedOUs -join "; " } else { "Not Linked" }
    $enforced = if ($enforcedLinks.Count -gt 0) { $enforcedLinks -join "; " } else { "Not Enforced" }

    # Verifica se tem Administrative Templates configurados
    $hasTemplates = $false
    foreach ($ext in $xml.GPO.Computer.ExtensionData.Extension) {
        if ($ext.Name -eq "Administrative Templates") { $hasTemplates = $true }
    }
    foreach ($ext in $xml.GPO.User.ExtensionData.Extension) {
        if ($ext.Name -eq "Administrative Templates") { $hasTemplates = $true }
    }
    $templateStatus = if ($hasTemplates) { "Yes" } else { "No" }

    # Adiciona ao resultado final
    $result += [PSCustomObject]@{
        GPO_Name        = $gpo.DisplayName
        GUID            = $gpo.Id
        UserStatus      = $userEnabled
        ComputerStatus  = $computerEnabled
        LinkedOUs       = $linkedOUs
        Enforced        = $enforced
        WMI_Filter      = $wmiFilter
        HasTemplates    = $templateStatus
        CreationTime    = $gpo.CreationTime
        ModificationTime= $gpo.ModificationTime
    }
}

# Exporta para CSV
$csvPath = "C:\Temp\All-GPOs-Export.csv"
$result | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "✅ Exportação concluída para: $csvPath"
