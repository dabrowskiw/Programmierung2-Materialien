#import "@preview/touying:0.6.1": *
#import "@preview/colorful-boxes:1.3.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: rect as fletcher_rect, ellipse as fletcher_ellipse, circle as fletcher_circle
#import "@preview/numbly:0.1.0": numbly
#import themes.university: *
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/cetz:0.5.2"

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
  config-common(new-section-slide-fn: none)
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
  subtitle: "Objektorientierte Programmierung",
  title: "Programmierung 2",
  institution-name: "HTW Berlin"
)

== Definition Vererbung

#slide[
  - Klassen auf Grundlage einer Basisklasse erstellen
  - Abgeleitete Klasse:
    - Übernimmt Fähigkeiten der Basisklasse
    - Kann diese erweitern
    #only(2)[- Kann diese verändern]
][
  #only(1)[
    #image(
     width: 100%,
     "Bilder/inheritance.png"
    )
  ]
  #only(2)[
    #image(
     height: 100%,
     "Bilder/programmers.png"
    )
  ]
]

== Vererbung: Syntax

#sourcecode[```java
modifikatoren class AbgeleiteteKlasse extends Basisklasse {
//...
}
```]

#sourcecode[```java
public class JavaProgrammer extends Programmer {
//...
}
```]

- Nur `public` und `protected`-Elemente werden vererbt!
- `private` weder vererbt noch von der abgeleiteten Klasse aus verwendbar
- Aufruf des Constructors der Basisklasse: `super(Argumente)`

== Beispiel Vererbung

#slide[
  #sourcecode[```java
    class A { // Basisklasse
      public int x;
      public A(int x) {
        this.x = x;
      }
    }
    class B extends A {
      public int y;
      public B(int x, int y) {
        super(x); 
        this.y = y;
      }
    }
    class C extends B {
      public int z;
      public C(int x, int y, int z) {
        super(x, y); 
        this.z = z;
      }
    }
  ```]
][
  #only(2)[
    #sourcecode[```java
      public class MyClass {
        public static void main(
                    String[] args) {
          C obj = new C(10, 20, 30);
          System.out.println(
            obj.x + " " + 
            obj.y + " " + 
            obj.z);
        }
      }
    ```]
  ]

  - Was wird ausgegeben?
  - Was wird in welcher Reihenfolge aufgerufen?
]

== Beispiel Point-Klasse

#slide(composer: (1.6fr, 1fr))[
  #sourcecode[```java
    class Point { 
      public int x;
      public int y;
      public Point(int x, int y) {
        this.x = x; this.y = y;
      }
    }
    class ColorPoint extends Point { 
      public String color;
      public ColorPoint(int x, int y, String c) {
        super(x, y);
        this.color = c;
      }
    }
    class Point3D extends ColorPoint { 
      public int z;
      public Point3D(int x, int y, int z, String c){
        super(x, y, c);
        this.z = z;
      }
    }
  ```]
][
  #only(2)[
    #sourcecode[```java
    public class MyClass {
      public static void main(
             String[] args) {
        Point3D p = new Point3D(
             10, 20, 30, "red");
        System.out.println(
          p.x + " " + p.y+" "+ 
          p.z + " " + p.color
        );
      }
    }
    ```]
  ]

  - Was wird ausgegeben?
  - Was wird in welcher Reihenfolge aufgerufen?
]

== Vererbung mit Methoden

#slide(composer: (1fr, 1fr))[
  #sourcecode[```java
  class Point {
    public void printPoint() {
      System.out.println(
        "Ich bin ein Punkt.");
    }
  }
  class ColorPoint extends Point {
    public void printColor() {
      System.out.println(
        "Ich habe eine Farbe.");
    }
  }
  class Point3D extends ColorPoint {
    public void print3D() {
      System.out.println(
        "Ich bin ein 3D-Punkt.");
    }
  }
  ```]
][
  #only(2)[
    #sourcecode[```java
    public class MyClass {
      public static void main(
            String[] args) {
        Point3D p = new Point3D();
        p.printPoint(); 
        p.printColor();
        p.print3D(); 
      }
    }
    ```]
  ]

  - Was wird ausgegeben?
  - Was wird warum aufgerufen?
]

== Überschreiben von Methoden

- Gleiche Signatur der Methode: Überschreiben


#sourcecode[```java
class A {
  public void func() {
    System.out.println("func von A");
  }
}
class B extends A {
  public void func() {
    System.out.println("func von B");
  }
}
public class MyClass {
  public static void main(String[] args) {
    A obj1 = new A();
    B obj2 = new B();
    obj1.func();
    obj2.func();
  }
}
```]

== Überschreiben: Point-Beispiel

#sourcecode[```java
  class Point { 
    public void print() {
      System.out.println("I am a Point");
    }
  }
  class ColorPoint extends Point {
    public void print() {
      System.out.println("I am a ColorPoint");
    }
  }
  public class MyClass {
    public static void main(String[] args) {
      ColorPoint p = new ColorPoint();
      p.print();
    }
  }
```]

Was wird ausgegeben?

== Überschreiben: Point-Beispiel

#sourcecode[```java
  class Point { 
    public void print() {
      System.out.println("I am a Point");
    }
  }
  class ColorPoint extends Point {
    public void print() {
      System.out.println("I am a ColorPoint");
    }
  }
  public class MyClass {
    public static void main(String[] args) {
      Point p = new ColorPoint();
      p.print();
    }
  }
```]

...und jetzt? 
#pause 
`p` ist zwar ein `Point`, "weiß" aber, dass es auch ein `ColorPoint` ist!

== Auflösen überschriebener Methoden

#slide[
  #sourcecode[```java
    class Point { 
      public void print() {
        System.out.println("I'm a Point");
      }
    }
    class ColorPoint extends Point {
      public void printColor() {
        System.out.println("I'm colored");
      }
    }
    public class FunnyPoint extends Point {
      public void print() {
        System.out.println("I'm funny");
      }
    }
  ```]
][
  #only(1)[
    #sourcecode[```java
      public class MyClass {
        public static void main(String[] a) {
          showPoint(new ColorPoint());
          showPoint(new FunnyPoint());
        }
        public void showPoint(Point p) {
          p.print();
          p.printColor();
        }
      }
    ```]
    - Was wird wann aufgerufen?
    - Gibt es einen Fehler?
  ]
  #only(2)[
    #sourcecode[```java
      public class MyClass {
        public static void main(String[] a) {
          showPoint(new ColorPoint());
          showPoint(new FunnyPoint());
        }
        public void showPoint(Point p) {
          p.print();
          if(p instanceof ColorPoint) {
            ColorPoint cp = (ColorPoint)p;
            cp.printColor()
          }
        }
      }
    ```]
    - `instanceof`: Klasse prüfen
    - Vorsicht bei Cast!
  ]
]

== Auflösung von Methoden: Recap Arrays und List

- Arrays und Listen können Objekte enthalten
- Casts können nötig sein, wenn Typ=Basisklasse

#slide[
  #sourcecode[```java
    class Point { 
      public void print() {
        System.out.println("I'm a Point");
      }
    }
    class ColorPoint extends Point {
      public void print() {
        System.out.println("I'm, uhm...");
      }
      public void printColor() {
        System.out.println("I'm colored");
      }
    }
  ```]
][
  #only(1)[
    #sourcecode[```java
      public class MyClass {
        public static void main(String[] a) {
          Point[] points = 
            {new Point(), new ColorPoint()}
          for(Point p : points) {
            p.print();
            if(p instanceof ColorPoint) {
              ((ColorPoint)p).printColor();
            }
          }
        }
      }
    ```]
    - Was wird wann aufgerufen?
  ]
  #only(2)[
    #sourcecode[```java
      public class MyClass {
        public static void main(String[] a) {
          Point[] ps = 
            {new Point(), new ColorPoint()}
          LinkedList<Point> points = new 
            LinkedList<>(Arrays.asList(ps));
          for(Point p : points) {
            p.print();
            if(p instanceof ColorPoint) {
              ((ColorPoint)p).printColor();
            }
          }
        }
      }
    ```]
    - `LinkedList<Point>`: Alle Elemente `instanceof Point`
  ]
]


== Liskow Substitution Principle

Vorsicht bei Überschreiben vererbter Methoden:
- Subklasse kann immer als Basisklasse übergeben werden!
- Empfangende Methode weiß nicht, ob und welche Subklasse sie bekommt!
- Unerwartetes Verhalten vermeiden: Liskov Subsitution Principle
  - Jede Subklasse sollte sich so wie die Basisklasse einsetzen lassen
  - Subklassen dürfen:
    - preconditions nicht verschärfen
    - postconditions nicht relaxieren

== Überladen von Methoden

- Unterschiedliche Signatur der Methode: Überladen

#sourcecode[```java
  class Point { 
    public void print() {
      System.out.println("Point");
    }
  }
  class ColorPoint extends Point {
    public void print(String color) { 
      System.out.println("ColorPoint in " + color);
    }
  }
  public class MyClass {
    public static void main(String[] args) {
      ColorPoint p = new ColorPoint();
      p.print(); // Welche Methode?
      p.print("red"); // Welche Methode?
    }
  }
```]

== Annotationen

- Annotationen: Zusatzinformationen für Compiler
- Ändern nicht Funktionsweise des Codes, aber definieren Randbedingungen
- `@Override`: Methode überschreibt etwas in Basisklasse

#only(1)[
  #sourcecode[```java
    class Point { 
      public void print() {
        System.out.println("I am a Point");
      }
    }
    class ColorPoint extends Point {
      @Override
      public void print() { // Korrekt: Gleiche Signatur
        System.out.println("I am a ColorPoint");
      }
    }
  ```]
]

#only(2)[
  #sourcecode[```java
    class Point { 
      public void print() {
        System.out.println("I am a Point");
      }
    }
    class ColorPoint extends Point {
      @Override
      public void print(String color) { // Compiler-Fehler: Kein override!
        System.out.println("I am a ColorPoint in " + color);
      }
    }
  ```]
]

== Methoden in Basisklasse aufrufen

Überschriebene Methoden können mit `super` aufgerufen werden

#sourcecode[```java
  class Point { 
    public void print() {
      System.out.println("I am a point");
    }
  }
  class ColorPoint extends Point {
    @Override
    public void print() {
      super.print();
      System.out.println("...and a ColorPoint");
    }
  }
  public class MyClass {
    public static void main(String[] args) {
      ColorPoint p = new ColorPoint();
      p.print(); // Was wird ausgegeben?
    }
  }
```]

== Überschreiben verhindern: `final`

- `final` verhindert das Überschreiben von Methoden:

#sourcecode[```java
  class Point { 
    public final void print() {
      System.out.println("I am a point");
    }
  }
  class ColorPoint extends Point {
    @Override
    public void print() { // Fehler: ist final!
      super.print();
      System.out.println("...and a ColorPoint");
    }
  }
```]

#pause

Aber warum sollte man das tun? "This element is not supposed to change, and if you want to change it, you haven't understood the existing design." 

== Beispiel für `final`: Template-Pattern

#slide(composer: (1fr, 1.2fr))[
  - Ablauf festgeschrieben
  - Details der Schritte frei
  #sourcecode[```java
    public class Workout {
      public final void doWorkout() {
        doCardio();
        doStrength();
        doCooldown();
      }
      public void doCardio() {
        System.out.println("Jog");
      }
      public void doStrength() {
        System.out.println("Pushups");
      }
      public void doCooldown() {
        System.out.println("Stretch");
      }
    }

  ```]
][
  #sourcecode[```java
    public class LegWorkout extends Workout {
      public void doCardio() {
        System.out.println("Skiprope");
      }
      public void doStrength() {
        System.out.println("Squats");
      }
      public void doCooldown() {
        System.out.println("Toe touch");
      }
    }
    public class MyWorkoutClass {
      public void workout(String day) {
        if(day.equals("Monday"))
          new LegWorkout().doWorkout();
        else if(day.equals("Friday"))
          new AbsWorkout().doWorkout();
      }
    }
  ```]
]

== Basisklasse von allem: Object

- Jede Klasse ist von `Object` abgeleitet (sozusagen implizit `extends Object`, aber Vorsicht, keine Mehrfachvererbung)
- Alle `Object`-Methoden sind verfügbar, z.B.:
  - `getClass()`
  - `toString()`
  - `equals(Object other)`

== getClass()

- Gibt eine Instanz von `Class` zurück
- Gibt zur Laufzeit Informationen über Objekt
- Hauptverwendung: Reflection, sonst lieber `instanceof` (warum?)

#sourcecode[```java
    public static void main(String[] args) {
        Point p = new Point();
        ColorPoint cp = new ColorPoint();
        myMethod(p);
        myMethod(cp);
    }

    public static void myMethod(Point p) {
        Class c = p.getClass();
        System.out.println(c.getName());
        for(Method m : c.getMethods()) {
            System.out.println("   " + m.getName());
        }
    }
```]

== toString()

- String-Darstellung des Objekts, Standard: Speicheradresse
- `System.out.println(Object o)` gibt `o.toString()` aus
- Überschreiben erlaubt schönere Ausgabe

#sourcecode[```java
  public class Point {
    protected int x, y;
    public Point(int x, int y) {
      this.x = x;
      this.y = y;
    }
    @Override
    public String toString() {
      return "Point at (" + x + ", " + y + ")";
    }
  }
```]

Recap-Fragen: Warum sind x, y `protected`? Ist `this.x = x` schön?

== equals(Object other)

- Überprüft, ob zwei Objekte identisch sind
- Standard-Überprüfung: Speicheradresse

#only("1-2")[
  #sourcecode[```java
    public static void main(String[] args) {
      String s1 = "Hello";
      String s2 = "Hel";
      String s3 = "lo";
      if(s1 == s2+s3)
        System.out.println(s1 + "==" + s2 + s3);
      else
        System.out.println(s1 + "!=" + s2 + s3);
    }
  ```]

  - Was wird ausgegeben?
]

#only(2)[
  - Randnotiz: Bei `s2 = "Hello"` wäre `s1==s2` #sym.arrow Stringpool
]

#only(3)[
  #sourcecode[```java
    public static void main(String[] args) {
      String s1 = "Hello";
      String s2 = "Hel";
      String s3 = "lo";
      if(s1.equals(s2+s3))
        System.out.println(s1 + "==" + s2 + s3);
      else
        System.out.println(s1 + "!=" + s2 + s3);
    }
  ```]

  - Was wird jetzt ausgegeben?
]

== equals-Beispiel: point

#slide[
  #sourcecode[```java
    public class Point {
      protected int x, y;
      public Point(int x, int y) {
        this.x = x;
        this.y = y;
      }
      @Override
      public boolean equals(Object other) {
        if(other instanceof Point) {
          Point p = (Point)other;
          return (p.x == x && p.y == y);
        }
        return false;
      }
    }
  ```]
][
  #sourcecode[```java
    public static void main(String[] a) {
      Point p1 = new Point(2, 2);
      Point p2 = new Point(2, 2);
      Point p3 = new Point(4, 8);
      System.out.println(p1 == p2);
      System.out.println(p1 == p3);
      System.out.println(p1.equals(p2));
      System.out.println(p1.equals(p3));
  }
  ```]

  Was gibt welche der Zeilen aus? Warum?
]

== Abstrakte Klassen

Wenn Struktur klar ist, aber Standard-Logik nicht sinnvoll: `abstract`

#sourcecode[```java
  public abstract class AbstractRoom {
    private int roomNumber; // Warum private?
    public AbstractRoom(int roomNumber) {
      this.roomNumber = roomNumber;
    }
    public int getRoomNumber() {
      return roomNumber;
    }
    public abstract int getFreeBeds();
    @Override
    public String toString() {
      return roomNumber + ": " + getFreeBeds();
    }
  }
```]

#pause - Wo haben wir ein Pattern gesehen, bei dem das sinnvoll wäre?
#pause 
- Geht `AbstractRoom room = new AbstractRoom()`? Warum?

== Ableitung von abstrakten Klassen

#slide(composer: (1fr, 1.2fr))[
- Subklassen müssen:
  - `abstract`-Methoden implementieren
  - Selber `abstract` bleiben 

  #sourcecode[```java
    public class SingleRoom 
             extends AbstractRoom {
      private boolean taken = false;
      public SingleRoom(
                  int roomNumber) {
          super(roomNumber);
      }
      @Override
      public int getFreeBeds() {
          return taken?0:1;
      }
    }
  ```]
][
  #sourcecode[```java
    public class SharedRoom 
                 extends AbstractRoom {
      private int numBeds, takenBeds;
      public SharedRoom(int roomNumber, 
            int numBeds) {
        super(roomNumber);
        this.numBeds = numBeds;
        this.takenBeds = 0;
      }
      @Override
      public int getFreeBeds() {
       return numBeds-takenBeds;
      }
    }
    //...
    public static void main(String[] a){
      AbstractRoom r1 = new AbstractRoom();
      SingleRoom r2 = new SingleRoom();
      AbstractRoom r3 = new SharedRoom();
      r2.toString(); // Welche Methode(n)?
    } // Was davon geht?
  ```]
]

== Alternativbeispiel: Shape

#slide[
  #sourcecode[```java
    public abstract class Shape {
      private String name;
      public Shape(String name) {
        this.name = name;
      }
      public String getName() {
        return name;
      }
      public abstract void draw();
      public abstract double getArea();
    }
  ```]
  Das Überschreiben von `draw()` sehen wir nochmal bei der GUI-Entwicklung.
][
  #sourcecode[```java
    public class Square extends Shape {
      private int width;
      public Square(int width) {
        super("Square");
        this.width = width;
      }
      public void draw() {/*...*/};
      public double getArea() {
        return width*width;
      }
    }

    public class Point extends Shape {
      public Circle(int diameter) {
        super("Point");
      }
      public void draw() {/*...*/};
      public double getArea() {
        return 0;
      }
    }
  ```]
]

== Exkurs: Composite-Pattern

#slide[
  - Sehen wir bei der GUI-Entwicklung wieder
  - Erlaubt es, Komplexe Objekt-Gruppen wie eins zu behandeln

  #sourcecode[```java
    public static void main(String[] a){
      Shape myShape = new Square(20);
      myShape.add(new Circle(10));
      myShape.add(new Square(2));
      myShape.add(new Point());
      myShape.draw(); // Was passiert?
    }
  ```]
  #only(2)[
    #cetz.canvas({
      import cetz.draw: *
      rect((0,0), (2,2))
      circle((1, 1), radius: 0.5)
      rect((0.8, 0.8), (1.2,1.2))
      circle((1, 1), radius: 0.01)
    })
  ]
][
  #sourcecode[```java
  public abstract class Shape {
      protected List<Shape> children;
      public Shape() {
          children = new LinkedList<>();
      }
      public final void draw() {
          drawSelf();
          for(Shape child : children) {
              child.draw();
          }
      }
      public abstract void drawSelf();
  }
  ```]
]

== Mehrfachvererbung

#slide[
  - Vererbung repräsentiert das Konzept "A ist ein B"
  - Was ist, wenn etwas mehrere Dinge ist?
  #only(2)[
  - Diamond inheritance problem
    #image(height: 40%, "Bilder/diamondinheritance.png")
  - Lösung in Java: Geht nicht.
  ]
][
  #sourcecode[```java
  public class Decoration {
    public String getFunction() {
      return "Decorative";
    }
  }
  public class Cookware {
    public String getFunction() {
      return "Cooking";
    }
  }
  public class PrettyPot
    extends Decorative, Cookware {
      //...
  }
  public static void main(String[] a) {
    PrettyPot pot = new PrettyPot();
    pot.getFunction(); // Was passiert?
  }
  ```]
]

== Alternativbeispiel Mehrfachvererbung

#slide[
  Spiel mit:
    - Spielzustand
    - Screenshots
    - Online oder lokal
  #sourcecode[```java
  public abstract class Saver {
    private List stuffToSave;
    // addStuff, constructor etc.
    protected final void saveStuff() {
      for(Object toSave : stuffToSave) {
        save(toSave);
      }
    }
    public abstract void save(
                        Object toSave);
  }
  ```]
][
  #sourcecode[```java
    public class CloudSaver extends Saver {
      @Override
      public void save(Object toSave) {
        saveToCloud(toSave);
      }
    }
    public class LocalSaver extends Saver {
      @Override
      public void save(Object toSave) {
        writeToDisk(toSave);
      }
    }
  ```]
  - `toString()`? Lieber `save()`
  - `Object`? Lieber Basisklasse.\ Aber welche?
]

== Interface

- Gemeinsame Basisklasse von `Screenshot` und `Gamestate`:
  - Etwas wie `GameElement` mit `save()`? Aber dann hat alles `save()`
  - `Saveable`? Aber dann können sie von nichts anderem erben.
#pause
- Lösung: `interface`
  - "Vollkommen abstrakte Klasse"
  - Nur Methodendeklarationen, keine Implementationen
  - Verspricht nur "Ich kann diese Dinge", sagt nicht wie \ #sym.arrow Keine Konflikte, wenn mehrere Interfaces das selbe versprechen!

== Interface-Beispiel: Savable

#slide[
  #sourcecode[```java
  public interface Saveable {
    public String save();
  }

  public abstract class Saver {
    private List<Savable> stuffToSave;
    // addStuff, constructor etc.
    protected final void saveStuff() {
      for(Savable toSave : stuffToSave){
        save(toSave);
      }
    }
    public abstract void save(
                        Savable toSave);
  }
  ```]
][
  #sourcecode[```java
    public class CloudSaver extends Saver {
      @Override
      public void save(Savable toSave) {
        saveToCloud(toSave.save());
      }
    }
    public class LocalSaver extends Saver {
      @Override
      public void save(Savable toSave) {
        writeToDisk(toSave.save());
      }
    }
  ```]
]

== Interface implementieren

- `implements` statt `extends`
- Beliebig viele Interfaces implementierbar

#sourcecode[```java
  public interface Saveable {
    public String save();
  }
  public class Screenshot implements Savable, Printable {
    @Override
    public String save() {
      return "I am a screenshot";
    }
  }
  public class GameState implements Savable, Playable, Sharable {
    @Override
    public String save() {
      return "I am a GameState";
    }
  }
```]

