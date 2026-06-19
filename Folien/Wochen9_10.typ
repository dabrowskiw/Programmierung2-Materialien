#import "@preview/touying:0.6.1": *
#import "@preview/colorful-boxes:1.3.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: rect as fletcher_rect, ellipse as fletcher_ellipse, circle as fletcher_circle
#import "@preview/numbly:0.1.0": numbly
#import themes.university: *
#import "@preview/cetz:0.5.2"
#import "@preview/codly:1.3.0": *
#import "@preview/mmdr:0.2.2": *
#show: codly-init
#import "@preview/codly-languages:0.1.10": *
#codly(
  languages: codly-languages,
  inset: 0.15em,
)

#let fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide
)

#set text(
  hyphenate: true,
  lang: "de"
)

#let bhtprimary = rgb("#00a0aa")

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Programmierung 2],
    institution: "HTW Berlin",
    author: "Prof. Dr.-Ing. P. W. Dabrowski"
  ),
  config-colors(
    primary: rgb("#76b900"),
    secondary: rgb("#0082D1"),
    tertiary: rgb("#FF5F00"),
    neutral-lightest: rgb("#ffffff"),
    neutral-darkest: rgb("#000000"),
  ),
)

#show link: underline

#show figure.caption: set text(size: 16pt)

#show quote.where(block: true): it => block(
  width: 100%,
  stroke: 1pt + gray,
  inset: 1em,
  radius: 5pt,
  it // Re-insert the quote content
)

#show raw.where(block: true): set text(size: 14pt)

#title-slide(
  subtitle: "Clean Code",
  title: "Programmierung 2",
  institution-name: "HTW Berlin"
)


#show quote.where(block: true): it => block(
  width: 100%,
  stroke: 1pt + gray,
  inset: 1em,
  radius: 5pt,
  it // Re-insert the quote content
)

== Motivation

- Wie viele Computer haben Sie heute benutzt? #pause
- Wer von Ihnen hat einen Führerschein? #pause
- Wer wollte Informatik studieren, um Menschen zu töten? #pause //Mediensystem, Knight Capital Group 2012, Toyota Unintended Acceleration 2009-2011
#only(4)[- Wer kann eine Zeile Code fehlerfrei schreiben?

  ```java
  public static int getSum(int a, int b) {
    // Code hier
  }
  ```
]
#only(5)[- Wer kann eine Zeile Code fehlerfrei schreiben?
- Wer kann fünf Zeilen Code fehlerfrei schreiben?
  ```java
  public static int getSumOfDigits(int[] digits) {
    // Code hier
  }
  ```

]
#only(6)[- Wer kann eine Zeile Code fehlerfrei schreiben?
- Wer kann fünf Zeilen Code fehlerfrei schreiben?
- Wer kann 5000 Zeilen Code fehlerfrei schreiben? 
]

== Sauberer Code

#slide[
Für wen schreiben wir Code? #pause

#figure(
    image("Bilder/wtfm.png", width: 90%),
    caption: [Messung von Code-Qualität @WTFsm]
  )
][
#pause

#quote(block: true, attribution: [Grady Booch])[Clean code is simple and direct. Clean code reads like well-written prose.]
]

#speaker-note[
  - Often quoted by Robert Martin, one of the authors of the Agile Manifesto
]

== Wie viele WTF/m? 

#text(size: 24pt, ```java
  public HTMLDoc getDocumentForDisplay(String ref) {
    Document refDoc = getDocByReference(ref);
    StringBuilder c = new StringBuilder();
    String[] docCont = refDoc.getString().split("\n");
    if(docCont[2].startsWith(">"))
      c.append("<div class='bq'>");
    else
      c.append("<div class='normal'>");
    for(String s : docCont)
      c.append(s.replace("^>+", ""));
    c.append("</div>");
    return new HTMLDoc(c);
  }
```)

== Prinzip der umgekehrten Pyramide

#slide(repeat: 6, self =>[
  #let (uncover, only, alternatives) = utils.methods(self)

  #grid(
    columns: (1fr, 1.2fr),
    gutter: 1em,
  [
    #figure(
      image("Bilder/InvertedPyramidFeatureWriting.png", height: 90%),
      caption: [Struktur eines Artikels @Pyramid]
    )
  ],
  [
    #only("2-5")[
      - Mann beißt Hund in Südindien @ManBitesDog
    ]
    #only("3-5")[
      - Mann:
        - Entenzüchter
        #uncover("4-")[- 65]
      - Hund:
        - Hatte Tollwut
        #uncover("4-")[- Viele Wildhunde]
      - Indien:
        - Staat Kerala
        #uncover("4-")[- Dorf Pakakkadavu]
      #uncover("5")[- Nicht "65-jähriger Entenzüchter in Pakakkadavu, wo Hunde..."]
    ]
    #only(6)[  Äquivalent für Code:
      - Eine Abstraktionsebene\ pro Methode 
      - Ausstieg immer möglich
      - Klare Namen
      - Kurz!]

  ])
])

== Refactored

#text(size: 24pt, ```java
  public HTMLDoc getQuotedHTMLMail(String mailReference) {
    Document mailDocument = getDocByReference(mailReference);
    if(mailDocument.isQuoted()) {
      return wrapInBlockquoteDiv(mailDocument);
    }
    else {
      return wrapInNormalDiv(mailDocument);
    }
  }
```)

#pause

Was hat mit dem ursprünglichen Code nicht gestimmt?

#pause

- $50%$ der Arbeit: Den Code zum Laufen kriegen
- Restliche $50%$: Den Code lesbar machen. Sonst: Code smell

#speaker-note[
  - Das war nur ein Beispiel
  - Jetzt weitere Dinge, die man tun kann
  - Wichtig: Es gibt kaum absolute Regeln!
    - Viele Dinge bringen tradeoffs mit sich
    - Bis in welches Detail man etwas durchexerziert ist oft situationsabhängig
  - Hier: 
    - Ideen und Grundhinweise
    - Unterschiedliche Leute und Communities haben unterschiedliche Meinungen
    - Habe versucht, möglichst wenig kontroverse Dinge zu zeigen, aber:
      - Zu fast jeder Folie lassen sich vermutlich erfahrene Entwickler finden, die sagen "Ja, aber..."
      - Am Ende entscheidet persönliche Erfahrung: Hinweise merken, versuchen anzuwenden, schauen wo man sich packt und eigene Schlüsse ziehen.
]

== SOLID

#grid(
  columns: (1.1fr, 1fr),
  [
    - Schlechter Code: Problem seit über 50 Jahren
    - No silver bullet! Aber:
      - Etablierte Erfahrungswerte
      - Abgeleitete Regeln
    - Beispiel: SOLID-Prinzipien
      - Single Responsibility
      - Open/Closed
      - Liskov Substitution
      - Interface Segregation
      - Dependency Inversion
    ],[
      #image("Bilder/solid.png", height: 100%)
    ]
)

== Single Responsibility Principle 

#slide[
  - Methode/Klasse sollte nur eine Sache tun
  - Was ist "eine Sache"?
    - Methode sollte nur einen Grund haben, sich zu ändern
    - "Extract method" nicht sinnvoll möglich
  - Überlange Methode: Code smell
][
  #image("Bilder/solid_s.png", height: 75%)
  Taschenmesser: Eine Klinge pro Aufgabe
]

== Ist das eine Sache?

#only(1)[
  #text(size: 24pt, ```java
    public HTMLDoc getQuotedHTMLMail(String mailReference) {
      Document mailDocument = getDocByReference(mailReference);
      if(mailDocument.isQuoted()) {
        return wrapInBlockquoteDiv(mailDocument);
      }
      else {
        return wrapInNormalDiv(mailDocument);
      }
    }
  ```)
]


#only("2-3")[
  #text(size: 24pt, ```java
    public HTMLDoc getQuotedMail(String mailReference) {
      Document mailDocument = getDocByReference(mailReference);
      return addHTMLDecoration(mailDocument);
    }

    public HTMLDoc addHTMLDecoration(Document mailDocument) {
      if(mailDocument.isQuoted()) {
        return wrapInBlockquoteDiv(mailDocument);
      }
      else {
        return wrapInNormalDiv(mailDocument);
      }
    }
  ```)
...hat das jetzt geholfen?
]

#only(3)[

  #sym.arrow No silver bullet! Mitdenken, Prinzipien zielorientiert einsetzen!
]

== Open-Closed-Principle

#slide[
- Code-Veränderung an einer Stelle sollte keine kaskadierenden Veränderungen verursachen
- Open-Closed-Prinzip:
  - Unveränderliche Module
  - Neue Funktionalität #sym.arrow
    - Hinzufügen neuer Module (neuer Code)
    - Keine Veränderungen existierenden Codes
][
  #image("Bilder/solid_o.png", height: 75%)
  Zug: Neue Waggons, ohne den ganzen Zug zu verändern
]

== Open-Closed-Beispiel

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1em,
  [
    ```java
public class Main {
  static void main() {
    File[] files = new FileSelector().getFiles();
    Arrays.stream(files).forEach(
        file -> {
          System.out.println(file);
        });
  }
}
    ```

    Neue Dateifilter?
    #only(2)[
      - `FileSelector` ändern
      - Open-Closed verletzt
    ]
  ],
  [
    ```java
public class FileSelector {
  public FileSelector() {}
  public File[] getFiles() {
    System.out
        .println("1) *.txt, 2) *.bat?");
    String sel = new Scanner(System.in)
        .next();
    if(sel.equals("1"))
      return new File(".").listFiles(
        file -> {
          file.getName().endsWith("txt");
        });
    if(sel.equals("2"))
      return new File(".").listFiles(
        file -> {
          file.getName().endsWith("bat");
        });
    return new File[0];
  }
}

    ```
  ]
)

== Open-Closed-Beispiel

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  [
    #only("1-2")[
    ```java
public class ExtensionFilter implements FileFilter {
  private String ext;
  public ExtensionFilter(String e) {
    this.ext = ext;
  }
  public boolean fits(File f) {
    return f.getName().endsWith(ext);
  }
  public String getName() {return ext;}
}
public class Main {
  static void main() {
    File[] files = new FileSelector(
      new FileFilter[] {
          new ExtensionFilter("txt"), 
          new ExtensionFilter("bat") }
    ).getFiles(); //...
  }
}
    ```
  ]
    #only(2)[...Neuer Filter?]
    #only("3")[
      #codly(highlighted-lines: (18,))
    ```java
public class SizeFilter implements FileFilter {
  private int size;
  public SizeFilter(int size) {
    this.size = size;
  }
  public boolean fits(File f) {
    return f.length() < size;
  }
  public String getName() {
    return "size < " + size;
  }
}
//...
File[] files = new FileSelector(
  new FileFilter[] {
      new ExtensionFilter("txt"), 
      new ExtensionFilter("bat"),
      new SizeFilter(1000),
    }).getFiles()
    ```
  ]

  ],
  [
    ```java
public interface FileFilter {
  public boolean fits(File f);
  public String getName();
}

public class FileSelector {
  FileFilter[] fs;
  public FileSelector(FileFilter[] f) {
    fs = f;
  }
  public File[] getFiles() {
    for(int i=0; i<fs.length; i++) {
      System.out.println(i+"): "
          +fs[i].getName());
    }
    String sel = new Scanner(System.in).next();
    int numF = Integer.parseInt(sel);
    return new File(".").listFiles(
      file -> fs[numF].fits(file));
  }
}
    ```
  ]
)

== Liskov Substitution Principle

`Audi instanceof Car` sagt aus: Audi ist ein 

== Argumente

- Wenige Argumente, Verwirrung vermeiden.
- Massive Argumentliste: Code smell #uncover("2-")[
  - Wenn sie konzeptionell zusammen gehören: Eine Klasse?
  - Vorteil: Einfacher zu lesen
  - Nachteil: Versteckte Komplexität
  - Daumenregel: Kann ich das Objekt natürlich benennen?]

#only(2)[
  #text(size: 24pt, ```java
    public String showPat(int age, int ID, int bill, int indent){
      String indentS = " ".repeat(indent);
      return String.format("%s Patient %d age %d bill %d",
              intentS, ID, age, bill)
    }
  ```)
]

#only(3)[
  #text(size: 24pt, ```java
    public String showPat(Patient pat, int indent) {
      String indentS = " ".repeat(indent);
      return String.format("%s Patient %d age %d bill %d",
              intentS, pat.getID(), pat.getAge(), pat.getBill())
    }
  ```)
]

#speaker-note[
  Probleme:
    - Schwer zu lesen (was macht die Methode genau mit jedem der Argumente)
    - Schwer wartbar: Änderung in Anzahl oder Reihenfolge der Argumente muss überall angepasst werden
    - Hinweis auf zu große Methode: Verletzt sie SRP?
  Argumente in eine Klasse, aber keine Monster-Klassen mit allem, was irgendwo mal zusammen verwendet wurde -> Auch code smell!
]

/*== Nebeneffekte

#slide(composer: (1.5fr, 1fr))[
- Command and Query Separation: 
  - Methoden sollten nur eins:
    - Etwas berechnen (query, mit `return`)
    - Zustand verändern (command, `void`) 
    - Nicht beides tun
  - Ideal: Query-Reihenfolge egal
  - Real: Pragmatische Entscheidung
- Möglichst keine return-Argumente// (Nebeneffekte, Randnotiz: Funktionale Programmierung)
][
  #quote(block: true, attribution: [Bertrand Meyer])[Asking a question should not change the answer]
]

== CQS violation

  #text(size: 24pt, ```java
    public String showPat(Patient pat, int indent) {
      String indentS = " ".repeat(indent);
      pat.setBill(pat.getBill() + getShowingCost());
      return String.format("%s Patient %d age %d bill %d",
              intentS, pat.getID(), pat.getAge(), pat.getBill())
    }
  ```)

- Verletzt CQS: Ändert unerwartet Patient-Objekt
- Alternative:
  - Zwei Methoden: Query (show) und Command (increase bill)
  - Aber dann: Immer an gemeinsamen Aufruf denken?
- Irgendwo muss CQS verletzt werden...

#speaker-note[
  - Prinzip muss verletzt werden, das ist OK - aber *bewusst*!
]

== CQS violation: Client wrapper

Üblich: Definierte API (REST), atomare Operationen (pop), Facade (hier)

  #text(size: 24pt, ```java
    // In Shower-Klasse
    public String showPat(Patient pat, int indent) { ... }
    // In Patient-Klasse
    public void increaseBill(int cost) {
      this.setBill(this.getBill() + cost);
    }
    // Client-Wrapper
    public void printPatientAndIncreaseBill(
                  Patient pat, Shower shower, int indent) {
      shower.printPat(pat, indent);
      pat.increaseBill(shower.getShowingCost());
    }
  ```)
*/

== Kommentare

#counter(figure.where(kind: image)).update(2)
#slide[
Kommentare können beim\ Code-Verständnis helfen. 

Aber:
- Müssen zu Code passen
- Degenerieren mit der Zeit
- Können verwirren
- Sind keine Ausrede für schlechten Code!
][
#figure(
    image("Bilder/comments.png", height: 95%),
    caption: [Fragwürdiger Kommentar @Comments]
  )
]

== Kommentar-Beispiele

Schlechte Kommentare erklären schlechten Code.

#only(1)[
  #text(size: 24pt, ```java
  // Gibt das Guthaben aller Haben-Unterkonten zurück
  public int getSum() {
    int s = 0; // Summe
    for(Account a : accounts) { // a: Unterkonto
      if(a.getType() == 2) { // 2: Haben-Konto
        s += a.getBalance();
      }
    }
    return s;
  }
  ```)
]

#only(2)[
  Besser: Code erklärt sich selber
  #text(size: 24pt, ```java
  public int getBalanceOfCreditAccounts() {
    int sumOfBalances = 0;
    for(Account subaccount : getSubAccounts()) {
      if(subaccount.isCreditAccount()) {
        sumOfBalances += subaccount.getBalance();
      }
    }
    return sumOfBalances;
  }
  ```)
]

== Kommentar-Beispiele

Gute Kommentare erklären Code, der sich nicht selber erklären kann.

  #text(size: 24pt, ```java
  // Sucht das Format hh:mm:ss EEE, MMM dd, yyyy
  Pattern timeMatcher = pattern.compile(
    "\\d*:\\d*:\\d* \\w*, \\w* \\d*, \\d*");
  ```)
  
/*  #pause

  #text(size: 24pt, ```java
  assertTrue(a.compareTo(a) == 0);    // a == a
  assertTrue(a.compareTo(b) != 0);    //a != b
  assertTrue(aa.compareTo(ab) == -1); // aa < ab
  assertTrue(bb.compareTo(ba) == 1);  // bb > ab
  ```)*/


== Kommentar-Beispiele

Schlechte Kommentare duplizieren Code - nicht hilfreich...

#only(1)[
  #text(size: 24pt, ```java
  public void printPatientInvoice(Patient pat) {
    // Invoice-Objekt holen
    Invoice patientInvoice = pat.getInvoice();
    // Wenn die Rechnung aktiv ist...
    if(patientInvoice.isActive()) {
      // Erst deaktivieren...
      patientInvoice.deactivate();
      // Dann ausgeben...
      patientInvoice.printToScreen();
      // Dann wieder aktivieren.
      patientInvoice.activate();
    }
  }
  ```)
]

#only(2)[
  ...und denkt man immer an's Anpassen?
  #text(size: 24pt, ```java
  public void printPatientInvoice(Patient pat) {
    // Invoice-Objekt holen
    Invoice patientInvoice = pat.getInvoice();
    // Wenn die Rechnung aktiv ist...
    if(patientInvoice.isPrintable()) {
      // Erst deaktivieren...
      // Dann ausgeben...
      patientInvoice.printToScreen();
      // Dann wieder aktivieren.
    }
  }
  ```)
]

/*
== Kommentar-Beispiele

Gute Kommentare geben notwendige Hintergrundinformation


  #text(size: 24pt, ```java
  // http://tools.ietf.org/html/rfc4180 suggests that CSV lines
  // should be terminated by CRLF, hence the \r\n.
  csvStringBuilder.append("\r\n");
  ```)

  #pause

  #text(size: 24pt, ```java
  final Object value = (new JSONTokener(jsonString)).nextValue();
  // Note that JSONTokener.nextValue() may return
  // a value equals() to null.
  if (value == null || value.equals(null)) {
      return null;
  }
  ```)
*/

== Praxisbeispiel: Erregerdiagnostik

#only(1)[
  #place(center, image(height: 100%, "Bilder/patholive.png"))
]
#only("2-3")[
  #text(size: 24pt, ```python
  # Parse RefSeq ID file and write foreground and
  # background files for HiLive. Args: refseq infile,
  # foreground outfile, background outfile, any number
  # of tax entries: foreground, last one is bg (host)
  bsl_dict = parse_refseq_file(
    "refseq_ids.csv", "fg.csv", "bg.csv",
    "Viruses", "Bacteria", "Hominidae")
  ```)
]
#only(3)[
  #text(size: 24pt, ```python
  bsl_dict = parse_refseq_file(
    "refseq_ids.csv", "fg.csv", "bg.csv",
    "Adenoviridae", "Flaviviridae", "Hominidae")
  ```)
]

#only(4)[
  #grid(
    columns: (1fr, 1.3fr),
    [
      #text(size: 24pt, ```python
        @dataclass
        class AnalysisSettings:
          file_locations:
            FileLocations
          organisms_of_interest:
            OrganismsOfInterest
          identity_cutoff: int
          hilive_version: str
          # ...
      ```)
    ],
    [
      #text(size: 24pt, ```python
        @dataclass
        class FileLocations:
          refseq_file: str
          background_file: str
          foreground_file: str
        @dataclass
        class OrganismsOfInterest:
          foreground_organisms: list[str]
          background_organisms: list[str]
      ```)
    ]
  )
  #text(size: 24pt, ```python
  bsl_dict = parse_refseq_file(
    analysis_settings.file_locations,
    analysis_settings.organisms_of_interest)
  ```)
]

== Zusammenfassung

- Sauberer, wartbarer Code: Gut lesbar. Viele Herangehensweisen, u.A.:
  - Abstraktionsebenen trennen, Dinge verständlich benennen
  - Möglichst keine Überraschungen verstecken
- Werkzeuge erlernen, dann üben, üben, üben...

#counter(figure.where(kind: image)).update(3)
#figure(
    image("Bilder/xkcd.png", width: 85%),
    caption: [Code Quality @XKCD]
  )



== Quellenangaben

#set text(size: 12pt)

#bibliography("Wochen9_10.bib", title: none)

