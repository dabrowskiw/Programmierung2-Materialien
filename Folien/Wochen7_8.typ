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
  subtitle: "GUI-Programmierung",
  title: "Programmierung 2",
  institution-name: "HTW Berlin"
)

= Java GUI customization: paint

== Zeichenoperationen in Swing

- Codebeispiele: Siehe #link("https://github.com/dabrowskiw/Programmierung2-PaintExamples")[git-repo]
- Jede `JComponent`:
  - Ist für eigene Zeichenoperationen zuständig
  - Kann Kinder enthalten #sym.arrow Composite-Pattern
- Lösung über Template-Pattern:
  - `paint(Graphics g)`-Methode: Koordiniert, (nicht überschreiben)
  - `paintCompoment(Graphics g)`: Zeichnet Inhalte, wird meist überschrieben
  - `paintBorder(Graphics g)`: Zeichnet Rahmen
  - `paintChildren(Graphics g)`: Zeichnet Kinder (meist `paint()` mit Ausschnitt aus `g`)
- `Graphics`: Abstrakte Basisklasse für Zeichenoperationen allgemein

== Minimalbeispiel paintComponent

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ ```java
    import javax.swing.*;
    import java.awt.*;

    public class PaintExample extends JFrame {
        private class PaintExamplePanel extends JPanel {
            public void paintComponent(Graphics g) {
                Graphics2D g2d = (Graphics2D) g;
                g2d.setColor(Color.RED);
                g2d.fillRect(0 , 0, getWidth(), getHeight());
            }
        }
        public PaintExample() {
            add(new PaintExamplePanel());
        }
        public static void main(String[] args) {
            new PaintExample().setVisible(true);
        }
    }
  ```],
  image("Bilder/win1.png")
)

Reihenfolge Aufrufe ab `PaintExample.paint()`?

== Graphics2D


- `Graphics2D`: `Graphics`-Implementation für 2D-Zeichenoperationen
  - Einfache Zeichenoperationen: Linie, Viereck, Kreis etc.
  - Transformationen: Rotation, affine Transformation
  - `String` und `Image` zeichnen
  - Vor Zeichenoperation: Farbe setzen ("Stift auswählen")
- `Color`: Farbdefinition
  - Enthält statische Attribute für Standard-Farben
  - Mehrere Constructor mit Gesamtwert/Einzelwerten für:
    - HSV: Hue, Saturation, Value
    - RBG: Red, Green, Blue
    - RGBA: Red, Green, Blue, Alpha


== Beispiel mit Bild und Text

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ ```java
    private class PaintExamplePanel extends JPanel {
        BufferedImage lily;
        public PaintExamplePanel() throws IOException {
            lily = ImageIO.read(new File("lily.png"));
        }
        public void paintComponent(Graphics g)  {
            Graphics2D g2d = (Graphics2D) g;
            g2d.drawImage(lily, 
              new AffineTransform(0.02f,0f,0f,0.02f,20,30), 
              null);
            g2d.setColor(new Color(0, 0, 255));
            g2d.drawString("A Lily", 20, 100);
        }
    }

  ```],
  image("Bilder/win2.png")
)

$"AffineTransform" = mat(
  "scaleX"cos(r), -"scaleY"sin(r), "transX";
  "scaleX"sin(r), "scaleY"cos(r), "transY";
  0, 0, 1;
)$


== Beispiel mit Bild und Text

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ ```java
    private class PaintExamplePanel extends JPanel {
        BufferedImage lily;
        public PaintExamplePanel() throws IOException {
            lily = ImageIO.read(new File("lily.png"));
        }
        public void paintComponent(Graphics g)  {
            Graphics2D g2d = (Graphics2D) g;
            g2d.drawImage(lily, new AffineTransform(
                0.014f,0.014f,-0.014f,0.014f,40,20),
              null);
            g2d.setColor(new Color(0, 0, 255));
            g2d.drawString("A Lily", 20, 100);
        }
    }

  ```],
  image("Bilder/win3.png")
)

$"AffineTransform" = mat(
  0.02 cos(45°), -0.02 sin(45°), 40;
  0.02 sin(45°), 0.02 cos(45°), 20;
  0, 0, 1;
)$

== Beispiel mit Bild und Text

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ ```java
    private class PaintExamplePanel extends JPanel {
        BufferedImage lily;
        public PaintExamplePanel() throws IOException {
            lily = ImageIO.read(new File("lily.png"));
        }
        public void paintComponent(Graphics g)  {
            Graphics2D g2d = (Graphics2D) g;
            g2d.drawImage(lily, new AffineTransform(
                0.014f,0.014f,-0.042f,0.042f,70,-20),
              null);
            g2d.setColor(new Color(0, 0, 255));
            g2d.drawString("A Lily", 20, 100);
        }
    }

  ```],
  image("Bilder/win4.png")
)

$"AffineTransform" = mat(
  0.02 cos(45°), -0.06 sin(45°), 70;
  0.02 sin(45°), 0.06 cos(45°), -20;
  0, 0, 1;
)$

== PaintBorder & Color

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ ```java
    private class PaintExamplePanel extends JPanel {
        BufferedImage lily;
        public PaintExamplePanel() throws IOException {
            lily = ImageIO.read(new File("lily.png"));
        }
        public void paintComponent(Graphics g)  {
          // ...
        }
        public void paintBorder(Graphics g) {
            Graphics2D g2d = (Graphics2D) g;
            BasicStroke stroke = new BasicStroke(
                    5.0f, BasicStroke.CAP_BUTT,
                    BasicStroke.JOIN_MITER, 10.0f,
                    new float[] {10, 5, 3}, 0.0f);
            g2d.setColor(Color.RED);
            g2d.setStroke(stroke);
            g2d.drawRect(0, 0, getWidth(), getHeight());
        }
    }
  ```],
  image("Bilder/win5.png")
)

== Composition revisited

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ ```java
    private class LetterPanel extends JPanel {
        private String text;
        public LetterPanel(String text, int x, int y) {
            this.text = text;
            setBounds(x, y, 20, 20);
        }
        public void paintComponent(Graphics g) {
            Graphics2D g2d = (Graphics2D)g;
            g2d.setColor(Color.RED);
            g2d.drawRect(0, 0, getWidth()-1, getHeight()-1);
            g2d.drawString(text, 5, 15);
        }
    }
    private class OuterPanel extends JPanel {
        public OuterPanel(int x, int y, int cld) {
            setLayout(null);
            setBounds(x, y, 100+30*cld, 100+100*cld);
            add(new LetterPanel("a", 10, 10));
            add(new LetterPanel("b", 40, 80));
            add(new LetterPanel("c", 60, 20));
            if(cld > 0) add(new OuterPanel(30, 100, --cld));
        }
    }
  ```],
  image("Bilder/win_comp1.png")
)

== Paint order

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ `paint()`: `paintComponent()`, dann `child.paint()` für alle Kinder
    #codly(highlighted-lines: (2, 4, 12, 13, 14, 15, 16))
  ```java
    private class OuterPanel extends JPanel {
        private Color c;
        public OuterPanel(int x, int y, int cld) {
            c = new Color(100, 100, 50*cld);
            setLayout(null);
            setBounds(x, y, 100+30*cld, 100+100*cld);
            add(new LetterPanel("a", 10, 10));
            add(new LetterPanel("b", 40, 80));
            add(new LetterPanel("c", 60, 20));
            if(cld > 0) add(new OuterPanel(30, 100, --cld));
        }
        public void paintComponent(Graphics g) {
            Graphics2D g2d = (Graphics2D)g;
            g2d.setColor(c);
            g2d.fillRect(0, 0, getWidth()-1, getHeight()-1);
        }
    }
  ```],
  image("Bilder/win_comp2.png")
)


== Composition effects - live ansehen

#grid(
  columns: (3fr, 1fr),
  gutter: 0.5em,
  [ #codly(highlighted-lines: (4, 5, 6, 7, 8, 9, 10, 11, 12))
    ```java
    private class OuterPanel extends JPanel {
        private Color c;
        public OuterPanel(int x, int y, int cld) {
            addMouseListener(new MouseListener() {
                public void mouseClicked(MouseEvent e) {
                    Rectangle bounds = getBounds();
                    setBounds(bounds.x-10, bounds.y-10, 
                          bounds.width, bounds.height);
                    repaint();
                }
                // mousePressed, mouseReleased etc.
            });
            c = new Color(100, 100, 50*cld);
            setLayout(null);
            setBounds(x, y, 100+30*cld, 100+100*cld);
            add(new LetterPanel("a", 10, 10));
            add(new LetterPanel("b", 40, 80));
            add(new LetterPanel("c", 60, 20));
            if(cld > 0) add(new OuterPanel(30, 100, --cld));
        }
        public void paintComponent(Graphics g) { /*...*/ }
    }
  ```],
  image("Bilder/win_comp3.png")
)

== Composition revisited

Der Vollständigkeit halber: Der `JFrame`

```java
    public CompositionExample() {
        setLayout(null);
        int children = 3;
        add(new OuterPanel(0, 0, children));
        setPreferredSize(new Dimension(100+30*children, 100+100*children));
        pack();
    }
```

== Pixelweises paintComponent

- `Graphics2D`: Linien, Zeichen etc. - aber nicht für low-level Pixelzugriff
- Alternative: `BufferedImage`, dann `paintComponent()`
- Historisch: "Double Buffering"

== Pixelweises paintComponent

#grid(
  columns: (5fr, 1fr),
  gutter: 0.5em,
  [
    ```java
    private class ImagePanel extends JPanel {
      private BufferedImage buf;
      public ImagePanel() {
        setPreferredSize(new Dimension(100, 200));
        buf = new BufferedImage(100, 200, BufferedImage.TYPE_BYTE_GRAY);
        updateImage();
      }
      public void paintComponent(Graphics g) {
        Graphics2D g2d = (Graphics2D) g;
        g.drawImage(buffer, 0, 0, null);
      }
      public void updateImage() {
        Random r = new Random();
        WritableRaster wr = buf.getRaster();
        for(int i=0; i<buffer.getWidth(); i++) {
          for(int j=0; j<buffer.getHeight(); j++) {
            wr.setPixel(i, j, new int[] {r.nextInt(0, 255)});
          }
        }
        repaint();
      }
    }
    ```],
  image("Bilder/win_buf1.png")
)

== Randnotiz: RGB

#grid(
  columns: (5fr, 1fr),
  gutter: 0.5em,
  [ #only(1)[#codly(highlighted-lines: (5, 14, 15, 16))]
    ```java
    private class ImagePanel extends JPanel {
      private BufferedImage buf;
      public ImagePanel() {
        setPreferredSize(new Dimension(100, 200));
        buf = new BufferedImage(100, 200, BufferedImage.TYPE_3BYTE_BGR);
        updateImage();
      }
      public void paintComponent(Graphics g) { /*...*/ }
      public void updateImage() {
        Random r = new Random();
        WritableRaster wr = buf.getRaster();
        for(int i=0; i<buffer.getWidth(); i++) {
          for(int j=0; j<buffer.getHeight(); j++) {
            int[] pixel = new int[] {r.nextInt(255), 
                            r.nextInt(255), r.nextInt(255)};
            wr.setPixel(i, j, pixel);
          }
        }
        repaint();
      }
    }
    ```],
  [
    #only(1)[#image("Bilder/win_buf2.png")
  ...Button? Zusammen.]
    #only(2)[#image("Bilder/win_buf3.png")
  Schaffen wir auch den mit `super`?]
  ]
)

= Quality of Life: Streams

== Stream-API

#link("https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html")[Stream-Interface]: "A sequence of elements supporting sequential and parallel aggregate operations"

#grid(
  columns: (1.5fr, 1fr),
  [
- Kürzere Schleifen-Version
- Typische Anwendungen:
  - Filter: Sucht nur passende Elemente
  - Map: Transformiert jedes Element
  - Reduce: Berechnet ein Gesamtergebnis
  - Concat: Verbindet zwei Streams
  - Distinct: Nur unique-Elemente
  - Sorted: Sortiert Elemente
- Oft verwendet für Logik: Anonyme Funktionen
],[
  ```java
String[] arr = 
    new String[] {"a","b","c"};
List<String> list = 
    Arrays.asList(arr);
Stream<String> s1 = 
    Stream.of("A", "B", "B");
Stream<String> s2 = 
    list.stream();
Stream<String> s3 = 
    Arrays.stream(arr);

List<String> l = s3.toList();

  ```
])

== Stream: Filter

#grid(
  columns: (1fr, 1.2fr),
  [
  ```java
public class StreamExamples {
  public static void withLoop() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    List<String> res = 
        new LinkedList<>();
    for(String val : vals) {
      if(val.startsWith("A")) {
        res.add(val);
      }
    }
  }
}
  ```],
  [
    #only(1)[
  ```java
public class StreamExamples {
  public static void withStream() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    List<String> res = vals.stream()
        .filter(StreamExamples::startsA)
        .toList();
  }

  public static boolean startsA(String s) {
      return s.startsWith("A");
  }
}
  ```
      `StreamExamples::startsA`: Übergabe einer Methode

      Alternative: Lambda-Funktion
   ]
    #only(2)[
      #codly(highlighted-lines: (8, 9, 10))
  ```java
public class StreamExamples {
  public static void withStream() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    List<String> res = vals.stream()
        .filter(v -> {
          return v.startsWith("A");
        })
        .toList();
  }
}
  ```
    Lambda-Funktion:
      - Anonyme
      - Codeblock mit return
      - Eine Zeile ohne return
   ]
    #only(3)[
      #codly(highlighted-lines: (8,))
  ```java
public class StreamExamples {
  public static void withStream() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    List<String> res = vals.stream()
        .filter(v -> v.startsWith("A"))
        .toList();
  }
}
  ```
   ]
  ]
)

== Stream: Map

Sehr häufige Operation, z.B.:
  - Filter auf alle Bilder einer Galerie anwenden
  - In einem Mail-Template für jeden Kunden den Namen einsetzen


#grid(
  columns: (1fr, 1.2fr),
  [
  ```java
public class StreamExamples {
  public static void mapWithLoop() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    List<Integer> res = new LinkedList<>();
    for(String val : vals) {
      int len = val.length();
      res.add(len);
    }
  }
}
  ```],
  [
  ```java
public class StreamExamples {
  public static void mapWithStream() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    List<Integer> res = vals.stream()
      .map(v -> v.length() )
      .toList();
    }
  }
}
  ```
  ]
)

== Stream: Reduce

Sehr häufige Operation, z.B.:
  - Summe aller Punktzahlen in einem Spiel 
  - Häufigkeitsklassen von Altern in einer Alstersliste


#grid(
  columns: (1fr, 1fr),
  [
  ```java
public class StreamExamples {
  public static void reduceWithLoop() {
    List<Integer> vals = Arrays.asList(
        new Integer[] {1, 2, 3, 4, 5});
    int sum = 0;
    for(Integer val : vals) {
      sum += val;
    }
  }
}
  ```],
  [
  ```java
public class StreamExamples {
  public static void reduceWithStream() {
    List<Integer> vals = Arrays.asList(
        new Integer[] {1, 2, 3, 4, 5});
    int sum = vals.stream()
        .reduce(0, (s, v) -> s+v );
  }
}
  ```
  ]
)

== Stream: Map-Reduce

- Operationen geben wieder Streams zurück #sym.arrow einfach kombinierbar
- Typisches Muster: "Map-reduce", später in Hadoop, Spark etc.

#grid(
  columns: (1fr, 1.1fr),
  [
  ```java
public class StreamExamples {
  public static void mapReduce() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    int lengthAsum = vals.stream()
      .filter(v -> v.startsWith("A"))
      .map(v -> v.length() )
      .reduce(0, (s, v) -> s+v );
  }
}
  ```

  #only(2)[
   Viele Berechnungen - geht das auch parallel?
  ]
],
  [
    #only(3)[
      #codly(highlighted-lines: (7,))
  ```java
public class StreamExamples {
  public static void mapReduce() {
    List<String> vals = Arrays.asList(
        new String[] {
          "Anna", "Brit", "Arne"
        });
    int lengthAsum = vals.parallelStream()
      .filter(v -> v.startsWith("A"))
      .map(v -> v.length() )
      .reduce(0, (s, v) -> s+v );
  }
}
  ```

    ]
  ]
)

#only(3)[
  - Parallel: Nutzt alle Kerne
  - Vorsicht: Overhead für Threads #sym.arrow Für komplexe Berechnungen
]

== Stream: Sorted

Sortieren nach definierter Reihenfolge: `Comparator` oder Lambda

#grid(
  columns: (1fr, 1fr),
  [
  ```java
    public static void sort() {
      List<String> vals = Arrays.asList(
          new String[] {"Anna", "Brit", "Charlie"});
      List<String> res = vals.stream()
        .sorted(new Comparator<String>() {
          public int compare(String o1, String o2) {
            return o1.length() - o2.length();
          }
        }).toList();
    }
  ```],
  [
  ```java
public class StreamExamples {
  public static void sort() {
    List<String> vals = Arrays.asList(
        new String[] {"Anna", "Brit", "Charlie"});
    List<String> res = vals.stream()
      .sorted((x, y) -> x.lenth()-y.length())
      .toList();
  }
}
  ```
  ]
)

Alternativen (aber nicht direkt mit `Stream` kombinierbar): 
- `Collections.sort(Collection<T>, Comparator<T>)`
- Interface `Comparable` mit `public int compareTo(Object other)`

= Nützliche Design Patterns

== Decorator

#grid(
  columns: (1fr, 1fr),
  gutter: 0.5em,
  [
    - Structural pattern
    - Transparentes Hinzufügen von Funktionalität
    - Komposition statt Vererbung:
      - Nur ein Objekt erweitern
      - Beliebig kombinierbar
      - Re-implementation aller public-Methoden von `component`
      #sym.arrow Sinnvoll bei Komponenten mit schlankem Interface 
  ],
  image("Bilder/decorator_uml.png"),
)

== Label-Decorator

```java
private abstract class LabelDecorator extends JLabel {
  private JLabel component;
  protected Color color;
  public LabelDecorator(JLabel component, Color c) {
    setPreferredSize(component.getPreferredSize());
    this.component = component;
    this.color = c;
  }
  public void paintComponent(Graphics g) {
    component.setSize(getSize());
    component.paint(g);
    Graphics2D g2d = (Graphics2D) g;
    decorate(g2d);
  }
  protected abstract void decorate(Graphics2D g2d);
}```

== Label-Decorator: Verwendung

#grid(
  columns: (4fr, 1fr),
  gutter: 0.5em,
  [```java
private class BorderDecorator extends LabelDecorator {
  public BorderDecorator(JLabel component, Color c) {
    super(component, c);
  }
  protected void decorate(Graphics2D g2d) {
    g2d.setColor(color);
    g2d.drawRect(0, 0, getWidth()-1, getHeight()-1);
  }
}
public DecoratorExample() {
  setLayout(new GridLayout(0, 1, 0, 50));
  add(new BorderDecorator(new JLabel("Hello!"), Color.RED));
  add(new BorderDecorator(new JLabel("Huhu!"), Color.BLUE));
  add(new JLabel("Keine Farbe"));
  pack();
}
  ```
  #only(2)[
    Kombination?
      - 2 Decorator statt 4 Label #sym.arrow steigt exponentiell 
      - Zusammen in IDEA: `StrikeoutDecorator`
  ]
  ],
  image("Bilder/win_dec1.png")
)

== Label-Decorator: Kombination

#grid(
  columns: (4fr, 1fr),
  gutter: 0.5em,
  [```java
private class StrikeoutDecorator extends LabelDecorator {
  public StrikeoutDecorator(JLabel component, Color c) {
    super(component, c);
  }
  protected void decorate(Graphics2D g2d) {
    g2d.setColor(color);
    g2d.drawLine(0, 0, getWidth(), getHeight());
    g2d.drawLine(0, getHeight(), getWidth(), 0);
  }
}
private class BorderDecorator extends LabelDecorator {
  // ...
}
public DecoratorExample() {
  setLayout(new GridLayout(0, 1, 0, 50));
  add(new BorderDecorator(new JLabel("Hello!"), Color.RED));
  add(new StrikeoutDecorator(new JLabel("Huhu!"), Color.BLUE));
  add(new BorderDecorator(
          new StrikeoutDecorator(new JLabel("Huhu!"), Color.RED),
          Color.BLUE));
  add(new JLabel("Keine Farbe"));
  pack();
}
  ```],
  [
    #only(1)[#image("Bilder/win_dec2.png")]
    #only(2)[
      #image("Bilder/win_fac1.png")
      Aber wie so was?
    ]
  ]
)

== Factory

#grid(
  columns: (1fr, 1fr),
  gutter: 0.5em,
  [
    - Creational pattern
    - Delegiert Objekterstellung
    - Laufzeit-Entscheidung, welche Klasse instanziiert wird
    - Erstellende Methode kennt nur Interface, nicht konkrete Klasse
    - Beispiel: DecoratorFactory, gemeinsam in IDEA
  ],
  image("Bilder/factory.jpg"),
)
 /*
== Singleton

Typ: Creational

== Strategy

Typ: Behavioral
*/
