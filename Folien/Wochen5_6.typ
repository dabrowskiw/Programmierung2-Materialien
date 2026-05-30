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
  subtitle: "GUI-Programmierung",
  title: "Programmierung 2",
  institution-name: "HTW Berlin"
)

= GUI-Design-patterns

== Design patterns

- Gängige Muster zur Lösung typischer Anforderungen
  - Keine feste Vorgehensweise, eher übliche Ideen
  - Coding best practices, die gemeinsame Sprache schaffen
- Typischer Weise unterteilt in:
  - Creational: Erstellt Objekte
  - Structural: Objekt-Organisation in größere Strukturen
  - Behavioral: Zusammenarbeit zwischen Objekten
  - Concurrency: Für Nebenläufigkeits-Probleme
- Weite Bekanntheit durch "Design Patterns: Elements of Reusable Object-Oriented Software" (GoF)

== Observer pattern

- Problem:
  - Dinge passieren mit etwas ("subject")
  - Andere Dinge wollen dann benachrichtigt werden ("observer")
- Beispiele:
  - Angeschlossene Geräte sollen benachrichtigt werden, wenn der Luftdruck des Kompressors sich ändert
  - Berechnungslogik soll benachrichtigt werden, wenn ein Button angeklickt wurde
- Typische Lösung: Observer Pattern
  - "Subject" hat Liste von "observer"-Objekten (interface #sym.arrow notify-Methode)
  - Ruft bei Zustandsänderung notify-Methode aller observer auf

== Observer-Minimalbeispiel

#sourcecode[```java
public interface ButtonObserver {
    public void onClick();
}
public class ClickObserver implements ButtonObserver {
    public void onClick() { System.out.println("Klick!"); }
} 
public class Button {
    private LinkedList<ButtonObserver> obs;
    public void addObserver(ButtonObserver o) {obs.add(ob); }
    public void buttonBlicked() {
        for(ButtonObserver o : obs) {
            o.onClick();
        }
    }
}
```]

== Event Handling in Swing

- Swing: Java-Bibliothek für GUI-Programmierung
- `JComponents` (subject) verwalten Liste von `EventListener` (observer)
- `EventListener` ist nur Interface
    - Werden konkret implementiert für konkrete Ereignistypen, z.B.:
        - `ActionListener`: Click auf Button etc.
        - `KeyListener`: Taste gedrückt/losgelassen
    - Methoden für konkrete Events, z.B. `KeyListener`: `keyPressed` etc.
- Konkrete `JComponents` haben spezialisierte Methoden für konkrete `EventListener`, z.B. `JButton.addActionListener()` - nicht für jede `JComponent` wären alle konkreten `EventListener` sinnvoll.

== Minimalbeispiel Event-Handling

#sourcecode[```java
public class SwingWindow extends JFrame {
    public SwingWindow() {
        super("Beispielfenster in Swing");
        setSize(400, 200);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JButton button = new JButton("Hallo!");
        button.addActionListener(new MyButtonListener());
        add(button);
    }
}
```]

#sourcecode[```java
public class MyButtonListener implements ActionListener {
    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println("Hello, world!");
    }
}
```]

#sym.arrow Gemeinsam in IDEA

== Composite pattern

...aber was soll das `add(button)`?

Häufiges Problem: Gruppen von Objekten, die wie eins behandelt werden sollen.

Lösung: Composite
- Baumartige Struktur gleichartiger Objekte
- Jedes kennt seine "Kinder", leitet relevante Aufrufe weiter

#sym.arrow Ein Objektbaum kann wie ein einzelnes Objekt genutzt werden

== Composite pattern

#slide[
#sourcecode[```java
public interface Drawable {
  public void draw();
}
public abstract class Brace 
                implements Drawable {
  protected LinkedList<Brace> 
       children = new LinkedList<>();
  public void addChild(Brace child) {
    children.add(child);
  }
  protected void drawChildren() {
    for(Brace child : children) {
      child.draw();
    }
  }
}
```]
#only(2)[
- Was passiert?
- Was wird ausgegeben?
]
][
  #sourcecode[```java
  public class RoundBrace extends Brace{
    @Override
    public void draw() {
      System.out.print("(");
      drawChildren();
      System.out.print(")");
    }
  }
  public static void main(String[] a) {
    Brace outer = new RoundBrace();
    outer.addChild(new RoundBrace());
    outer.draw();
  }
```]
- `LinkedList` hier gut?
- `drawChildren` protected?
- Welches Pattern von letzter Woche würde zusätzlich passen?
]

== Composite pattern in Swing

#slide[
  - Container:
    - Können beliebig verschachtelt sein
    - Haben überschreibbare `paint`-Methode
    - Oberstes Element: `JFrame`
    - Darunter: Beliebig `JPanel`
    - Blätter: `JComponent`/`JPanel`
  - Jede `Component` hat `LayoutManager` #sym.arrow unterschiedliche Arten, Kinder zu positionieren
][
  #image("Bilder/swingclasses.png", width: 100%)
]

== Kompletter Fensteraufbau

#sourcecode[```java
public class SwingWindow extends JFrame {
  public SwingWindow() {
    setSize(400, 200);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setLayout(new FlowLayout());
    add(new JButton("Hallo"));
    add(new JButton("Huhu"));
  }
}
public class Main {
  public static void main(String[] args) {
    new SwingWindow().setVisible(true);
  }
}
```]

Gemeinsam in IDEA
- Mehrere Zeilen mit Buttons durch mehrere `JPanel` und `BoxLayout`
- Ausprobieren unterschiedlicher #link("https://docs.oracle.com/javase/tutorial/uiswing/layout/visual.html")[LayoutManager]: Box, Border, Grid

= Event handling und innere Klassen

== Innere Klassen

- Eigene Klassen für alle `Listener` etc. #sym.arrow Explosion von Klassen
- Alternative: Innere Klassen
  - Enge Kopplung: Existieren nur im Kontext der äußeren Klasse
  - Kapselung: Verbirgt Hilfsklassen, macht Code lesbarer
  - Zusätzlicher Namensraum zu Paketen: Gruppiert zusammengehörende Klassen
  - Lesbarkeit: Weniger Top-Level-Klassen
- Typen:
  - Konventionell: Einfach Klasse in Klasse
  - Statisch: Mit `static`
  - Lokal: Klasse innerhalb einer Methode
  - Anonym: Inline, ohne Namen

== Konventionelle innere Klassen

- Immer an Instanz der äußeren Klasse gebunden
- Kann auf `private` der äußeren Klasse zugreifen!
- Für Attributzugriff auf Attribut `attr`:
  - Wenn eindeutig (nur äußere oder nur innere) es hat: `attr`
  - Explizit auf Attribut der inneren Klasse: `this.attr`
  - Explizit auf Attribut der äußeren Klasse `Outer`: `Outer.this.attr`

== Instanziierung von außen

#sourcecode[```java
public class MyClass {
  public static void main(String[] args) {
    A obj = new A();
    A.B obj2 = obj.new B();
    obj2.func();
  }
}
public class A {
  private int x = 5;
  public class B {
    private int x = 10;
    public void func() {
      System.out.println(x);
      System.out.println(this.x);
      System.out.println(A.this.x);
    }
  }
}
```]

Was wird ausgegeben? Warum?

== Instanziierung von innen

#sourcecode[```java
public class MyClass {
  public static void main(String[] args) {
    A obj = new A();
    obj.b.func();
  }
}
public class A {
  private int x = 5;
  public B b; // Welche Alternativen zu public gibt es?
  public A() { 
    b = this.new B();
  }
  public class B {
    private int x = 10;
    public void func() {
      System.out.println(A.this.x);
    }
  }
}
```]

== Account und Card

#slide[
#sourcecode[```java
class BankAccount { 
  private String holder;
  private double balance;
  BankAccount(String holder, 
              double balance) {
    this.holder = holder;
    this.balance = balance;
  }
  void deposit(double amount) {
    balance += amount;
  }
  double getBalance() {
    return balance;
  }
  String getHolder() {
    return holder;
  }
}
```]
][
  #sourcecode[```java
class Card { 
  private BankAccount account;
  Card(BankAccount account) {
    this.account = account;
  }
  void deposit(double amount) {
    account.deposit(amount);
  }
  void showBalance() {
    System.out.println(
      "Balance of " 
      + account.getHolder() 
      + ": " 
      + account.getBalance()
    );
  }
}
```]
]

== Verwendung ohne interne Klasse

#sourcecode[```java
public class TestAccountCard {
  public static void main(String[] args) {
    BankAccount account = new BankAccount("Alice", 100);
    Card card = new Card(account);
    card.deposit(50);     // +50
    card.showBalance();   // Balance of Alice: 150.0
  }
}
```]

== Account und Card

#sourcecode[```java
class BankAccount {
  private String holder;
  private double balance;
  BankAccount(String holder, double balance) {
    this.holder = holder;
    this.balance = balance;
  }
  void deposit(double amount) {
    balance += amount;
  }
  class Card { // konventionelle innere Klasse
    void deposit(double amount) {
      BankAccount.this.deposit(amount); // Warum nicht direkt balance += account?
    }
    void showBalance() {
      // Direkter Zugriff auf private-Attribute
      System.out.println("Balance of " + holder + ": " + balance);
    }
  }
}
```]

== Verwendung mit interner Klasse

#sourcecode[```java
public class TestAccountCard {
  public static void main(String[] args) {
    BankAccount account = new BankAccount("Alice", 100);
    BankAccount.Card card = account.new Card();
    card.deposit(50);     // +50
    card.showBalance();   // Balance of Alice: 150.0
  }
}
```]

== Separate vs. innere Klasse 

#table(
  columns: (1fr, 1fr, 1fr),
  [*Aspekt*], [*Separate Klasse*], [*Innere Klasse*],
  [*Datenzugriff*], [Nur über Getter/Setter], [Direkter Zugriff möglich - aber nicht immer gute Idee],
  [*Kopplung*], [Lose Kopplung], [Enge Kopplung an konkretes Account-Objekt],
  [*Objekt-Erstellung*], [new Card(account)], [account.new Card()], 
  [*Zugehörigkeit*], [Kann zu jedem Account gehören], [Gehört zu genau einem äußeren Account],
  [*Sichtbarkeit*], [`public` oder package-private], [Kann `private` sein (dann aber nur intern verwendbar)]
)

== Statische innere Klasse

- Gehört zur äußeren Klasse, nicht zu einer Instanz (Objekt)
- Hat keinen Zugriff auf nicht-statische Attribute
- Dient zur Gruppierung von konzeptionell zusammengehöriger Logik

#grid(
  columns: (1fr, 1fr),
  gutter: 25pt,
sourcecode[```java
public class A {
  private static int x = 5;
  private int y = 10;

  public static class B {
    public void func() { 
      // Was davon geht?
      System.out.println(x);
      System.out.println(y);
    }
  }
}
```],
sourcecode[```java
public class MyClass {
  public static void main(String[] a){
    // Keine Instanz von A nötig!
    A.B obj = new A.B();
    obj.func();
  }
}
```]
)

== Externer Account-Manager

#slide[
  #sourcecode[```java
  class BankAccount {
    private String holder;
    private double balance;
    BankAccount(String holder, double balance) {
      this.holder = holder;
      this.balance = balance;
    }
    double getBalance() {
      return balance;
    }
  }
```]
][
  #sourcecode[```java
class Manager {                     
  private List<BankAccount> accs = 
                        new LinkedList<>();
  void add(BankAccount acc) {
    accounts.add(acc);
  }
  void showTotalBalance() {
    double total = 0;
    for (BankAccount acc : accs) {
      total += acc.getBalance();
    }
    System.out.println("Balance: " 
                        + total);
  }
}
  ```]
]

== Verwendung


#sourcecode[```java
  public static void main(String[] args) {
    BankAccount a1 = new BankAccount("Alice", 100);
    BankAccount a2 = new BankAccount("Bob", 200);
    Manager manager = new Manager();
    manager.add(a1);
    manager.add(a2);
    manager.showTotalBalance(); // Total Balance: 300.0
  }
```]

== Interner Account-Manager


#sourcecode[```java
class BankAccount {
    private String holder;
    private double balance;
    BankAccount(String holder, double balance) {
        this.holder = holder;
        this.balance = balance;
    }
    static class Manager { // Statische innere Klasse
        private java.util.List<BankAccount> accounts = new java.util.ArrayList<>();
        void add(BankAccount acc) {
            accounts.add(acc);
        }
        void showTotalBalance() {
            double total = 0;
            for (BankAccount acc : accounts) {
                total += acc.balance;
            }
            System.out.println("Total Balance: " + total);
        }
    }
}
```]

== Verwendung

#sourcecode[```java
public class TestAccount {
    public static void main(String[] args) {
        BankAccount a1 = new BankAccount("Alice", 100);
        BankAccount a2 = new BankAccount("Bob", 200);
        // Instanz der statischen inneren Klasse (kein BankAccount nötig!)
        BankAccount.Manager mgr = new BankAccount.Manager();
        mgr.add(a1);
        mgr.add(a2);
        mgr.showTotalBalance(); // Total Balance: 300.0
    }
}
```]

== Separate vs. static inner 

#table(
  columns: (1fr, 1fr, 1fr),
  [*Aspekt*], [*Separate Klasse*], [*Innere Klasse*],
  [*Datenzugriff*], [Nur über Getter/Setter], [Zugriff auf private *statische* Felder],
  [*Kopplung*], [Lose Kopplung], [Enge logische Bindung an die äußere Klasse],
  [*Objekt-Erstellung*], [new Manager()], [new Account.Manager()], 
  [*Zugehörigkeit*], [Eigener Typ], [Gehört zum *Namespace* von BankAccount],
  [*Sichtbarkeit*], [`public` oder package-private], [Kann `private` sein (dann aber nur intern verwendbar)]
)


== Anonyme innere Klassen

- Werden innerhalb einer Methode erzeugt
- Haben keinen eigenen Namen
- Haben keinen Constructor #sym.arrow Müssen Klasse erben oder Interface implementieren

== Beispiel anonyme innere Klasse

#sourcecode[```java
public class MyClass {
  public static void main(String[] args) {
    final int x = 10; // Muss final sein
    A obj = new A() { // Anonyme innere Klasse
      private int у = 20;
      @Override
      public void func() {
        System.out.println(x); // Zugriff auf lokale Konstante - Stack?
        System.out.println(у); // Zugriff auf das Feld dieser Klasse
        System.out.println(z); // Zugriff auf das Feld der Klasse A
      }
    };
    obj.func(); // Ausgabe? 
  }
}
class A {
  public int z = 30;
  public void func() {
    System.out.println("A.func()");
  }
}
```]

== Event-Handler

Mit separater Klasse:

#sourcecode[```java
public class SwingWindow extends JFrame {
    public SwingWindow() {
        super("Beispielfenster in Swing");
        setSize(400, 200);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JButton button = new JButton("Hallo!");
        button.addActionListener(new MyButtonListener());
        add(button);
    }
}
```]

#sourcecode[```java
public class MyButtonListener implements ActionListener {
    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println("Hello, world!");
    }
}
```]

== Event-Handler

Mit anonymer innerer Klasse:

#sourcecode[```java
public class SwingWindow extends JFrame {
  public SwingWindow() {
    setSize(400, 200);
    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    JButton button = new JButton("Hallo);
    button.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent e) {
        System.out.println("Button pressed!");
      }
    });
    add(button);
  }
}
```]

- Verhindert Proliferation von Mini-Klassen
- Direkter Zugriff auf Attribute/Methoden der umgebenden Klasse

== Enumerations

- Gibt spezifischen, erlaubten Werten Namen
- Macht Zustands-Variablen einfacher lesbar

#grid(columns: (1fr, 1fr),
  gutter: 25pt,
  sourcecode[```java
public class EnumExample {
  public void printColor(int col) {
    if(col == 0)
      System.out.println("red");
    else if(col == 1)
      System.out.println("blue");
  }
}
  ```],
  sourcecode[```java
public class EnumExample {
  public enum Color {RED, BLUE};
  public void printColor(Color col) {
    if(col == Color.RED)
      System.out.println("red");
    else if(col == Color.BLUE)
      System.out.println("blue");
  }
}
  ```],
)

= Übliche GUI-Komponenten

== JFrame

- Hauptfensterklasse, oberstes Element der `JComponent`-GUI-Hierarchie
- Wichtige Methoden:
  - `setVisible(boolean visible)`: Sichtbar machen
  - `setDefaultCloseOperation(int operation)`: Effekt des Schließens
  - `setSize(int w, int h), setLocation(int x, int y)`

#sourcecode[```java
public class Main {
    public static class SwingWindow extends JFrame {
        public SwingWindow() {
            super("A window!"); // Fenster-Titel
            setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        }
    }
    public static void main(String[] args) {
        new SwingWindow().setVisible(true);
    }
}
```]

== JButton

- Darstellung von Buttons mit Text/Icon
- Hauptlistener: `ActionListener`

#sourcecode[```java
public class SwingWindow extends JFrame implements ActionListener {
    public SwingWindow() {
        super("A window!");
        JButton myButton = new JButton("Hallo!");
        myButton.addActionListener(this);
        add(myButton);
        pack(); // Layout-Berechnung forcieren
    }
    public void actionPerformed(ActionEvent e) {
        System.out.println("Button clicked: " + e.getActionCommand());
    }
    public static void main(String[] args) {
        new SwingWindow().setVisible(true);
    }
}
```]

== JLabel

- Darstellung von Text oder Icon
- Nicht für Interaktion, trotzdem geerbte Listener

#sourcecode[```java
public class SwingWindow extends JFrame implements MouseMotionListener {
    public SwingWindow() {
        setLayout(new FlowLayout());
        JLabel label = new JLabel("Ich höre auf die Maus...");
        label.addMouseMotionListener(this);
        add(label);
        add(new JLabel(" ...und ich nicht."));
        pack();
    }
    public void mouseDragged(MouseEvent e) { }
    public void mouseMoved(MouseEvent e) {
        System.out.println("Mouse moved to: " + e.getPoint());
    }
}
```]

== JPanel

- Gruppierung von Elementen - oder Überschreiben von paint.


#sourcecode[```java
public class SwingWindow extends JFrame {
    public SwingWindow() {
        setLayout(new BoxLayout(this.getContentPane(), BoxLayout.PAGE_AXIS));
        JPanel p1 = new JPanel();
        p1.setLayout(new FlowLayout());
        p1.add(new JLabel("Das ist ein Button:"));
        p1.add(new JButton("Hallo!"));
        JPanel p2 = new JPanel();
        p2.setBackground(Color.RED);
        p2.add(new JLabel("Ich habe kein Layout!"));
        add(p1);
        add(p2);
    }
  }
}
```]

== JOptionPane

- Schnelle Art, Popup anzuzeigen
- Viele Typen/Aussehen über statische convenience-Methoden

#sourcecode[```java
public class SwingWindow extends JFrame {
    public SwingWindow() {
        JButton button = new JButton("Sag hallo!");
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                JOptionPane.showMessageDialog(null, "Hallo!", 
                    "Hallo-Nachricht", JOptionPane.ERROR_MESSAGE);
            }
        });
        add(button);
        pack();
    }
    public static void main(String[] args) {
        new SwingWindow().setVisible(true);
    }
}
```]

== Weitere

- Viele vordefinierte Komponenten
- Übersicht mit Beispielen auf #link("https://docs.oracle.com/javase/tutorial/uiswing/components/componentlist.html")[Oracle-Dokumentationsseite]
- Grundlegend gute Idee: In JavaDoc suchen, Methoden überfliegen
- Später im Semester: Anpassung durch Überschreiben von `paint()`
