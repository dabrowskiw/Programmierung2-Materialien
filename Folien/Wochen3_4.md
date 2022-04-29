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
  * Statue braucht Künstler, Alter und Material
  * Bild braucht Künstler, Alter und verwendete Farben
* Zwei offensichtliche Lösungen:
  * Alles in eine Klasse packen - aber diese Klasse wird riesig
  * Separate Klassen - aber viel Code wird identsich sein
* Dritte Lösung: Klassen können sich Code teilen

---

# Vererbung: Umsetzung

```java
public class Kunstwerk {
  public String kuenstler;
  public int alter;
  public String printDescription() { return alter+"Jahre altes Kunstwerk"; }
}
public class State extends Kunstwerk {
  public String material;
}
public class Bild extends Kunstwerk {
  public LinkedList<String> farben;
}
Bild meinBild = new Bild();
meinBild.alter = 15; // Geht, denn Bild kann alles, was Kunstwerk kann
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
Bild meinBild = new Bild(); // Kunstwerk hat alter, Bild nicht
meinBild.alter = 15;
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

# Abstrakte Klassen

---

# Interfaces

---


# Exceptions

---

# Typisierte Klassen