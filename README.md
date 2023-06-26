# ViSuM
Visuelle Suche nach Markenkennzeichen

(Bilder/screenshot.jpg "Screenshot")

**ViSuM** ist eine Referenzimplementation für eine *ViSA* (visual search 
application) auf KI-Basis, welche im Sinne eines proof of expenses erstellt 
wurde.

Zielsetzung der Anwendungsentwicklung war den Aufwand abzuschätzen, welcher 
benötigt wird um als ambitionierter Laie ein Anwendung zu erstellen die
eine visuelle Suchmöglichkeit bietet. 
Visuelle Suchmöglichkeit bedeutet, dass zur Suche nicht eine verbale
Beschreibung sondern ein Bild genutzt wird. 

Die Möglichen Anwendungsbereiche sind vielfältig. Drei Beispiele sollen dies
aufzeigen: 

1. Menschen mit Asperger-Syndrom eine Hilfestellung zur Erkennung von
Emotionen erbracht werden
2. interessante Orte von Photos erkannt werden um den nächsten Urlaub zu planen
3. umfangreiche Bildkataloge eingegrenzt werden z.B. um potentielle
Markenrechtsverletzungen im Anschluss personell weiter zu prüfen 

## Zielerreichung

Zielsetzung war den Aufwand abzuschätzen, den die Entwicklung einer solchen
Anwendung verursacht. Die Machbarkeit im Sinne eines proof of concepts war
nicht zu prüfen, da die generelle Funktionalität ein Standardbeispiel für
KI-Anwendungen ist. 

* Die Nettozeit liegt etwa bei 4 bis 6 Stunden und damit kleiner als ein 
Personentag in der Entwicklung.
* Dazu kommt die Zeit für die Aufbereitung der Trainingsdaten (hier Bilder)
welche sich für den hier dargestellten Anwendungstest auf ca. 2 Stunden 
aufaddiert. Allerdings ist da schon die "Spielzeit" eingerechnet, da man mit
**CreateML** so schön die Ergebnisse auch Menschengerecht aufbereitet
bekommen kann.

## Ergebnisse

Es liegen zwei Anwendungen hier vor:

1. **ViSAML** ein Kommandozeilenwerkzeug um das Training der KI von der 
UI CreateML zu trennen und das Model (LogoClassifier.mlmodel) z.B. in CI/CD
zu integrieren. Dies ist eine sehr rohe Implementierung.
2. **ViSuM** die App für iPhone, iPad und auf Apple Silikon lauffähige 
SwiftUI Anwendung zur mobilen Anwendung. Verwendet werden kann dabei sowohl
die Fotobibliothek des Gerätes als auch die Kamera. Das Ergebnis wird über
das Foto an der unten rechten Bildschirmseite eingeblendet.

Generell sind die Ergebnisse der Fachlichkeit stark von dem eigentlichen 
Modell und dessen Training abhängig.

Trainingsdaten können beispielsweise unter Kaggle.com bezogen werden wobei
die Eingrenzung auf die passende Lizenz für die Daten hierbei positiv
hervorzuheben ist.


## Lizenz

Non-Use License

Die Möglichkeiten KI-Anwendungen rechtlich konform in Einsatz zu bringen,
insbesondere bei generischen sozusagen "general purpose AI aplications",
welche durch das Model bestimmt werden sind, falls dies überhaupt für
Privatpersonen oder KMU leistbar ist, aktuell nicht berechenbar.

Sollte eine Nutzung oder Prüfung gewünscht sein, ist entsprechend zunächst
eine Relizensierung zu irgendeiner Lizenz vorzunehmen.

