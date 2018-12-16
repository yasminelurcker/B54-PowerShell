Clear-Host

$chemin = "C:\TEMP\index.html"

If (-Not ( Test-Path $chemin ))
{
New-Item $chemin -ItemType "file" | Out-Null

Set-Content $chemin -Value @"
<!DOCTYPE html>
<html lang="fr">
  <head>
    <title>adr1.formation.local</title>
    <meta charset="utf-8"/>
  </head>
  <body>
    <H1>Ordinateur: Serveur virtuel 2</H1>

    <H2>Site par adresse: 192.168.1.101:80</H2>

    <H2>Nom du site: adr1.formation.local</H2>
  </body>
</html>
"@
}
