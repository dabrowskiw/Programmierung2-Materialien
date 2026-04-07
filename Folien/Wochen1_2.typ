#import "@preview/touying:0.6.1": *
#import "@preview/colorful-boxes:1.3.1": *
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import fletcher.shapes: diamond, ellipse
#import "@preview/numbly:0.1.0": numbly
#import themes.university: *
#import "@preview/codelst:2.0.2": sourcecode

#set text(
  hyphenate: true,
  lang: "de"
)

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Programmierung 2 (IKG)],
    date: "SoSe 26",
    institution: "HTW Berlin",
    author: "Prof. Dr.-Ing. P. W. Dabrowski"
  ),
  config-colors(
    primary: rgb("#76b900"),
    secondary: rgb("#0082D1"),
    tertiary: rgb("#FF5F00"),
    neutral-lightest: rgb("#ffffff"),
    neutral-darkest: rgb("#000000"),
  )
)

#show link: underline

#show figure.caption: set text(size: 20pt)

#show bibliography: set text(size: 16pt)

#title-slide()

= Organisatorisches

== Mitmachen & bestehen

- Selber programmieren wichtig -> 1 SWS VL, 3 SWS PCÜ
- Präsenzzeit reicht *nicht*!
  - Regelmäßige Hausaufgaben
  - Fragen stellen (Forum, SL)! 
  - Üben, frustriert sein, üben (bester Prädiktor für Erfolg)
- Prüfungsleistung: 
  - E-Klausur: Programmieraufgabe -> ohne ChatGPT etc.!
  - Voraussetzung: 2 Hausaufgaben-Vorstellungen
    - 1x FASTA-Aufgabe, 1x DICOM-Aufgabe
    - Selber in der Übung melden - jede Übung max. 4-5 Leute
    - Ich clone repo, bei mir Code zeigen, erklären!

== Boni

- Alternative zu Prüfungsleistung: Projekt
  - Rechtzeitig mit mir reden, um Umfang zu definieren
  - Muss alle Konzepte des Moduls beinhalten
  - Sprache, Thema sind egal
  - Vorstellung am Semesterende
- Bonuspunkte für Verbesserungsvorschläge (siehe #link("https://github.com/dabrowskiw/Programmierung2-Materialien")[#underline("git-repo")]): 2.5% für Vorschlag, 5% für Code (mail, pull request), max. 2/Semester

= Allgemeine Hintergründe

== Fahrplan

- Konsequente Arbeit mit gradle und git(hub)
- Weitere Konzepte der Objektorientierung
- Grundlagen UI: CLI und GUI (Swing)
- Design komplexerer Programme
- Zwei Projekte
  - DNA-basierte personlisierte HIV-Medikation
  - Anzeigeprogramm für medizinische Bilddaten

== Gradle: Aufgaben und Abhängigkeiten

#figure(
  image("Bilder/gradle-basic-1.png", height: 95%),
  caption: [Gradle-Übersicht @gradleDeclaringManaging]
)

#speaker-note[
  - Ablauf Sourcecode -> Programm:
    - Sources finden
    - Dependencies (build-time) finden und laden
    - Programm bauen
  - Ablauf Ausführung:
    - Dependencies (run-time) finden und laden
    - Hauptklasse finden und ausführen
  - Gradle:
    - Automatischer Download Dependencies
    - Ordner alle richtig setzen
    - Richtige Parameter für Compilieren und Ausführen
    - Unterschiedliche Parametersätze für Aufgaben:
      - Bauen für diverse Zielsysteme, Ausführen, Tests...
      - Vordefinierte Parametersätze über Plugins
]

== Gradle-Beispiel: Erste Aufgabe

#sourcecode[```groovy
repositories { mavenCentral() }
dependencies {
    testImplementation 'org.junit...-api:5.8.1'
    testRuntimeOnly 'org.junit...-engine:5.8.1'
    implementation 'org.knowm.xchart:xchart:3.8.0'
}
java { 
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    } 
}
application { mainClass = 'org.htw....MyProject' }
tasks.named('test') { useJUnitPlatform() }
```
]

#speaker-note[
  - Einzelne Bereiche erklären:
    - Herkunft der Abhängigkeiten
    - Externe Abhängigkeiten für Bauen und Laufzeit
    - XChart: Plot darstellen
    - Mindest-Sprachversion definieren
    - Hauptklasse (z.B. falls mehrere main-Methoden)
    - Spezielle Aufgaben definieren, hier test, können aber auch build-Ziele etc. sein
  - Komplexe Konfigurationen möglich, hoher Automatisierungsgrad z.B. für code-checks, Deployment...
]

== Git: Kurz-Recap 1. Semester

- Sourcecode-Verwaltung: Versionierte Zwischenstände, Sicherung etc.
- Recap - siehe EKG, Quellen hier oder Youtube-Tutorials
- Unterstützung insbesondere in der 1. Übung, danach Voraussetzung - auch im Arbeitsleben!

#figure(
  image("Bilder/gitoverview.png", width: 100%),
  caption: [Überblick über den git-workflow @gitoverview]
)

== Git: Arbeiten im Team 

#figure(
  image("Bilder/gitteam.png", width: 100%),
  caption: [Gemeinsames Arbeiten an einem git-Repository @gitteam]
)

#speaker-note[
  - Verteiltes Arbeiten: Jeder eigenes lokales Repo, Synchronisation über zentrales Repo
  - Aber: Alle müssen Schreibzugriff auf zentrales Repo haben!
  - Hier nicht der Fall, daher Alternative nötig
]

== Git fork

#figure(
  image("Bilder/gitfork.png", height: 95%),
  caption: [Team-Workflow mit forking @gitfork]
)

#speaker-note[
  - Forks: Komplette, remote-Kopie - wie git clone, aber remote
  - Forkende Person hat volle Schreibrechte auf Fork!
  - Zurückspielen von Änderungen in Original-Repo: 
    - Pull Request (bitte übernimm meine Änderungen)
    - Bei Hausaufgaben Pull Requests nicht nötig
    - Abgaben nicht mehr lokal, sondern Fork, den ich clonen kann!
]

= Java Packages

== Motivation

- Java Class Library enthält über 4000 Klassen
- Organisation in hierarchischen Paketen
  - Thematisch zusammenhängende Klassen im selben Paket
  - Verhinderung von Namenskollisionen, z.B.:
    - `java.util.List`: Datentyp "Liste"
    - `java.awt.List`: Graphische Komponente zur Darstellung einer Auswahlliste
  - Erlaubt access modifier `protected`: Nur für Klassen im selben Paket verfügbar ("zwischen" `public` und `private`)
- Eigene Klassen in eigenen Paketen verhindern Kollisionen zwischen unterschiedlichen Projekten

== Verwendung von Paketen

- Paketname = Ordnername, `.` statt `/`
- Muss als `package` deklariert sein 
  - Ordnername muss identisch mit dem Paketnamen sein
  - Ähnlich: Klassenname muss identisch mit Dateiname sein
  - Name "Umgekehrt" zu Web-URL: `tld.Organisation.Details`
- Alle Klassen aus dem selben Paket sind implizit importiert

#figure(
  sourcecode[```java
  package org.htw.prog2ikg;

  public class PackageExample {
  //...
  }
  ```],
  caption: [Beispiel für eine Java-Datei `org/htw/prog2ikg/PackgeExample.java`]
)

#speaker-note[
  - Anforderung wie bei Klassennamen!
    - Dateiname = Klassenname
    - Ordnername = Paketname
  - Wo liegt der Ordner mit den ganzen Paketordnern? Definiert über Gradle-Konfiguration.
]

== Verwendung von Paketen (II)

- Klassen können aus Paketen importiert werden (alle mit `*`)
- Kein Import aus `default`-Paket (ohne Unterordner) möglich!
- Bei Namenskollision: Paketname mit angeben ("fqn")

#figure(
  sourcecode[```java
  import org.htw.prog2ikg.Aufgabe0;
  import org.htw.ekg.*;

  public class PackageExample {
    public void mymethod() {
      org.htw.ekg.Aufgabe0 = new org.htw.ekg.Aufgabe0();
    }
  }
  ```],
  caption: [Beispiel für Importe und Verwendung von fully qualified name.]
)

== Externe Pakete

- Fremder Code als "Bibliothek" einbindbar
- Konfiguration über gradle als dependency
- Viele Quellen, häufig: #link("https://mvnrepository.com/", [Maven])
- Beispiel: #link("https://mvnrepository.com/artifact/org.knowm.xchart/xchart", [XChart])
  - Bei Maven finden
  - Version aussuchen
  - Gradle-Konfiguration übernehmen
  - #link("https://knowm.org/open-source/xchart/xchart-example-code/", [Codebeispiele]) von der Homepage und #link("https://javadoc.io/doc/org.knowm.xchart/xchart/latest/index.html", [JavaDoc]) als Startpunkte


== Literatur

#bibliography("sources.bib", title: none)
