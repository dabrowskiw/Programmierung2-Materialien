#import "@preview/touying:0.6.1": *
#import "@preview/colorful-boxes:1.3.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: rect as fletcher_rect, ellipse as fletcher_ellipse, circle as fletcher_circle
#import "@preview/numbly:0.1.0": numbly
#import themes.university: *
#import "@preview/cetz:0.5.2"
#import "@preview/codly:1.3.0": *
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

- Jede `JComponent`:
  - Ist für eigene Zeichenoperationen zuständig
  - Kann Kinder enthalten #sym.arrow Composite-Pattern
- Lösung über Template-Pattern:
  - `paint(Graphics g)`-Methode: Koordiniert, wird meist nicht überschrieben
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

= Nützliche Design Patterns

== Singleton

Typ: Creational

== Factory

Typ: Creational

== Decorator

Typ: Structural

== Strategy

Typ: Behavioral

