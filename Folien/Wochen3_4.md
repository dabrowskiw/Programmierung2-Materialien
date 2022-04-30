---
marp: true
theme: HTW
paginate: true
footer: Dr. Katrin Lang / Prof. Dr.-Ing. P. W. Dabrowski - Programmierung 2 - HTW Berlin
---

# Testing

* Steigende Komplexität von Software -> Mehr Möglichkeiten für Fehler
  * Durch Übersehen von Randbedingungen
  * Durch Logikfehler
  * Durch Nebeneffekte beim Beheben anderer Fehler
* Lösung: Software testen. Aber:
  * Dauert bei steigender Komplexität lange
  * Fehleranfällig
* Lösung: Software testet sich selber automatisch

---

# Unit tests

* JUnit: Framework, um Tests zu automatisieren
* Idee: Jeder Test überprüft, ob eine Funktionalität korrekt ist
* Beispiel: Testen, was passiert, wenn Datei nicht existiert (aus HA 1):

```java
@Test
void isValid_doesNotExist() {
    SeqFile seqfile = new SeqFile("data/DOESNOTEXIST");
    assertFalse(seqfile.isValid());
}
```

* Ideal: Kleinteilige Tests, Randbedingungen abgedeckt
* Summe aller Tests = Test suite

---

# Test Driven Development

* Übliche Herangehensweise: Code schreiben, dann Tests schreiben
  * Stärke solcher Test suites: Regression vermeiden
  * Logikfehler kaum aufzudecken: Tests folgen gleicher Logik wie Code
* Alternative: Test Driven Development (TDD)
  * 1: Überlegen, was die fachlichen Anforderungen an den Code sind
  * 2: Tests schreiben (die failen, weil kein Code da ist)
  * 3: Code schreiben, der Tests erfüllt
  * 4: Schauen, ob Aufräumen/Refactoring nötig ist
  -> Das machen Sie hier (nur Tests schreiben Sie noch nicht selber)!

---

# Vererbung: Motivation

* Häufiges Problem bei größeren Programmen: Ähnliche, aber nicht ganz identische Dinge (z.B. "Statue" und "Bild"):
  * Statue braucht Künstler, Preis und Material
  * Bild braucht Künstler, Preis und verwendete Farben
* Zwei offensichtliche Lösungen:
  * Alles in eine Klasse packen - aber diese Klasse wird riesig
  * Separate Klassen - aber viel Code wird identsich sein
* Dritte Lösung: Klassen können sich Code teilen

---

# Vererbung: Umsetzung

```java
public class Kunstwerk {
  public String kuenstler;
  public int price;
  public String printDescription() { return price+"€ teures Kunstwerk"; }
}
public class Statue extends Kunstwerk {
  public String material;
}
public class Bild extends Kunstwerk {
  public LinkedList<String> farben;
}
Bild meinBild = new Bild();
meinBild.price = 15000; // Geht, denn Bild kann alles, was Kunstwerk kann
meinBild.material="Oel auf Leinen"; // Geht nicht, das kann nur Statue!
```

---

# Auflösung von Attributen und Methoden

Von der konkreten zur allgemeinen Klasse. Hier wird erst in `Bild` geschaut: Hat `farben` -> wird verwendet
```java
Bild meinBild = new Bild(); // Bild extends Kunstwerk, Bild hat farben
meinBild.farben.add("Rot");
```

Sonst werden der Reihenfolge nach die Eltern gefragt, bis jemand es hat. Hier hat `Bild` es nicht, also wird bei `Kunstwerk` geschaut -> Treffer

```java
Bild meinBild = new Bild(); // Kunstwerk hat price, Bild nicht
meinBild.price = 15000;
```

---

# Überschreiben

Das bedeutet, Kinder können sich anders verhalten, als Eltern!

```java
public class Uhr {
  public String tick() { return "Tick, tock"; }
}
public class Turmuhr extends Uhr {
  public String tick() { return "TICK! TOCK!"; }
}
Uhr swatch = new Uhr();
System.out.println(swatch.tick()); // Tick, tock
Turmuhr bigBen = new Turmuhr();
System.out.println(bigBen.tick()); // TICK! TOCK!
```

---

# Wer bin ich eigentlich?

Überprüfung, was die Klasse eines Objekts ist, mit `instanceof`:

```java
public class Uhr {
  public String tick() { return "Weiß ich nicht :("; }
}
public class Turmuhr extends Uhr {
  public String tick() { return "TICK! TOCK!"; }
}
public class Armbanduhr extends Uhr {
  public String tick() { return "Ticketacke."; }
}
Turmuhr bigBen = new Turmuhr();
boolean isTurmuhr = bigBen instanceof Turmuhr; // true
boolean isUhr = bigBen instanceof Uhr; // true
boolean isArmbanduhr = bigBen instanceof Armbanduhr; // false
```

---

# Exceptions

* Eine der Verwendungen in Java: Exception handling
* Bisher: Rückgabe von "Signalwerten":

```java
public int getNumberOfLetters(String text) {
  if(text == null) { // Dann kann keine Buchstabenzahl bestimmt werden
    return -1; // Fehlerwert
  }
  return text.length();
}
String text = getInputFromUser();
int letters = getNumberOfLetters(text);
if(letters == -1) {
  System.out.println("Etwas ist bei der Eingabe schief gelaufen!");
}
```

---

# Exceptions (II)

Fehlerwerte gehen aber nicht immer:

```java
public int getLetterDiff(String text1, String text2) {
  return text1.length() - text2.length(); 
}
```

* Problem: Alle Werte könnten richtige Ergebnisse sein
* Lösung: Zusätzlicher Informationskanal: Exception

---

# Exceptions (III)

Exception wikt wie "sofort `return`, bis zum nächsten passenden `catch`"

```java
public int getLetterDiff(String text1, String text2) throws Exception {
  if(text1 == null || text2 == null) {
    throw new Exception("Keiner der Texte darf null sein!");
  } 
  return text1.length() - text2.length(); 
}
String text = getUserInput();
try {
  int diff = getLetterDiff(text, "Referenzwort");
} catch(Exception e) {
  System.out.println("Etwas ist bei der Eingabe schief gelaufen");
}
```

---

# Exceptions (IV)

Einige Formalitäten bei Exceptions:

* Exception, die es aus der `main()` raus schafft, führt zum Programmabbruch
* Alle Exceptions erben von der `Exception`-Klasse
* Wenn eine Exception geworfen wird, muss sie
  * entweder mit `catch` gefangen werden
  * oder mit `throws` im Methodenkopf deklariert werden (und von der aufrufenden Methode gefangen/deklariert werden)
  * Ausnahme: Von `RuntimeException` ableitende Exceptions

---

# Arbeiten mit Exceptions: Codefluss

Exceptions erlauben, bei Fehlern direkt zur Fehlerbehandlung zu springen

```java
public int getLengthSum(String[]][] values) {
  int lengthSum = 0;
  try {
    for(int i=0; i<values.length; i++) {
      for(int j=0; j<values[i].length; j++) {
        lengthSum += values[i][j].length();
      }
    }
  } catch(NullPointerException e) {
    // Fehlerbehandlung, egal wo oben die Exception geflogen ist - ohne 
    // boolean flags und viele "if(error) break"
  }
}
```

---

# Arbeiten mit Exceptions: Fehlertypen

Unteschiedliche Fehlerursachen können unterschiedliche Fehlermeldungen und/oder unterschiedliche Fehlergbehandlung benötigen - catch ist hier wie `instanceof` für die Exception:
```java
public String readData(String filename) 
                    throws FileNotFoundException, FileFormatException { ... }

try {
  readData("inputfile.txt");
} catch(FileNotFoundException e) {
  System.out.println("Datei wurde nicht gefunden");
}  catch(FileFormatException e) {
  System.out.println("Fehler im Dateiformat:" + e.getMessage());
}
```

---

# Typisierte Klassen

Andere Nutzung von Objektorientierung: Typensicherheit bei Collections

* Bereits bekannt aus `LinkedList<String>` etc.
* Alles ist ein `Object` -> `LinkedList` kann beliebige Objekte halten
* Aber unklare Typisierung ist potenzielle Fehlerquelle
```java
LinkedList myList = new LinkedList();
myList.add(new String("Das ist ein Text"));
myList.add(new Double(5.0));
String text = (String)(myList.get(1)); // Fehler! myList.get(1) ist Double!
```

* Typisierte Klassen legen verwaltete Klasse fest -> Fehler unmöglich.

---

# Typisierte Klassen (II)

Typisierte Klassen kann man selber schreiben:
```java
public class KunstKollektion<T> {
  private LinkedList<T> objects = new LinkedList<T>();
  public void addObject(T exponat) { objects.add(exponat); }
  public T getObject(int num) { return objects.get(num); }
}
KunstKollektion<Bild> bildKollektion = new KunstKollektion<Bild>();
bildKollektion.addObject(new Bild()); // geht
bildKollektion.addObject(new Statue()); // geht nicht!
```

...aber was, wenn man Kunstwerk-spezifische Dinge tun will?

---

# Typisierte Klassen (III)

```java
public class KunstKollektion<T extends Kunstwerk> {
  private LinkedList<T> objects = new LinkedList<T>();
  public void addObject(T exponat) { objects.add(exponat); }
  public T getObject(int num) { return objects.get(num); }
  public int getTotalPrice() {
	int res = 0;
    for(Kunstwerk k : objects) { // geht, weil T ein Kunstwerk sein muss
      res += k.price;	
    }
    return res;
  }
}
KunstKollektion<Statue> bildKollektion = new KunstKollektion<Statue>();
bildKollektion.addObject(new Statue()); // geht
int totalPrice = bildKollektion.getTotalPrice();
```
