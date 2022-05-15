import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JMenuBar;
import javax.swing.JMenu;
import javax.swing.JMenuItem;

import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.GridBagLayout;
import java.awt.GridBagConstraints;
import java.awt.Dimension;

public class LayoutDemoFrame extends JFrame {
	JLabel label1 = new JLabel("Label 1");
	JLabel label2 = new JLabel("Label 2");
	JTextField tf1 = new JTextField();
	JButton button1 = new JButton("Button 1");
	JButton button2 = new JButton("Button 2");
	JMenuBar menuBar = new JMenuBar();
	JMenu menu = new JMenu("Click me");
	JMenuItem helloItem = new JMenuItem("Hi there!");
	JMenuItem otherItem = new JMenuItem("I'm another item");
	
	public LayoutDemoFrame() {
		super("Layout demo window");
        setSize(400, 100);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        initMenu();
        init_flowlayout();
//        init_gridlayout();
//        init_borderLayout();
//        init_gridbagLayout();
        pack();
	}
	
	public void initMenu() {
		menuBar.add(menu);
		menu.add(helloItem);
		menu.add(otherItem);
		setJMenuBar(menuBar);
	}
	
	public void init_flowlayout() {
		setLayout(new FlowLayout());
		addElements();
	}

	public void init_gridlayout() {
		setLayout(new GridLayout(2,3));
		addElements();
	}

	public void addElements() {
		add(label1);
		add(tf1);
		add(button1);
		add(label2);
		add(button2);
		tf1.setPreferredSize(new Dimension(80, 24));
	}

	public void init_borderLayout() {
		setLayout(new BorderLayout());
		add(label1, BorderLayout.NORTH);
		add(button1, BorderLayout.WEST);
		add(tf1, BorderLayout.CENTER);
		add(button2, BorderLayout.EAST);
		add(label2, BorderLayout.SOUTH);
		tf1.setPreferredSize(new Dimension(80, 24));
	}

	public void init_gridbagLayout() {
		setLayout(new GridBagLayout());
		GridBagConstraints gc = new GridBagConstraints();
		gc.gridx = 0;
		gc.gridy = 0;
		add(label1, gc);
		gc.gridx++;
		add(tf1, gc);
		gc.gridx++;
		add(button1, gc);
		gc.gridy++;
		gc.gridx = 0;
		add(label2, gc);
		gc.gridx++;
		gc.gridwidth=2;
		gc.fill = GridBagConstraints.HORIZONTAL;
		add(button2, gc);
		tf1.setPreferredSize(new Dimension(80, 24));
	}
}
