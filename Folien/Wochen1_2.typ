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

== Literatur

#bibliography("sources.bib", title: none)
