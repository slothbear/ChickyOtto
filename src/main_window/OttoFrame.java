import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.Point;
import java.awt.image.BufferedImage;

import javax.swing.ButtonGroup;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRadioButton;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JTextField;
import javax.swing.WindowConstants;

import net.miginfocom.swing.MigLayout;

public class OttoFrame extends JFrame {
	private static final long serialVersionUID = 911078009934658231L;
	
	ImageArea image_area = new ImageArea(this);
	private static final Color accentColor = new Color(0, 70, 213);

	private JButton capture_farm = new JButton("capture");
    
	private JButton locate_farm = new JButton("locate");
	// TODO: remove these defaults -- should come from model.
	//JLabel farm_location = new JLabel("0,0") ;
	Point farm_location = new Point(0,0);
	
	private JButton locate_coop = new JButton("locate");
	Point coop_location = new Point(0,0);
	
	private JButton locate_primers = new JButton("locate");
	Point primer_location = new Point(0,0);
	private JTextField primer_rows = new JTextField(3);
	private JTextField primer_columns = new JTextField(3);
	private JRadioButton white_primers = new JRadioButton("white", true);
	private JRadioButton brown_primers = new JRadioButton("brown");
	private JRadioButton black_primers = new JRadioButton("black");
	private JRadioButton golden_primers = new JRadioButton("golden");
	private JCheckBox remove_primer = new JCheckBox("remove primer before collecting?", true);

	private JButton locate_premiums = new JButton("locate");
	Point premium_location = new Point(0,0);
	private JTextField premium_rows = new JTextField(3);
	private JTextField premium_columns = new JTextField(3);
	
	private JTextField white_premiums = new JTextField(3);
	private JTextField brown_premiums = new JTextField(3);
	private JTextField black_premiums = new JTextField(3);
	private JTextField golden_premiums = new JTextField(3);
	
	private JLabel status_message = new JLabel(
	  "<html><font color=green>idle</font></html>");

	private JButton tend_button = new JButton("tend coop");
	
	public void setImage(BufferedImage img) {
		image_area.setImage(img);
	}
	
	public OttoFrame() {
		this.setTitle("Farmer Otto");
		String constraints = ""; //"debug";
		JPanel panel = 
			new JPanel(
				new MigLayout(
						constraints, "20[right][right][right][right]10"));

		addSeparator(panel, "capture farm");
		panel.add(capture_farm, "wrap");
		
		addSeparator(panel, "locate farm");
		panel.add(locate_farm);		
		panel.add(new JLabel("top left of farm area"), "span 3, wrap");
	
		addSeparator(panel, "coop");
		panel.add(locate_coop);
		panel.add(new JLabel("middle bottom nest"), "span 3, wrap");

		addSeparator(panel, "primer pen");
		panel.add(locate_primers);
		panel.add(new JLabel("back left chicken eye"), "span 3, wrap");
		panel.add(new JLabel("rows"), "split 2");
		panel.add(primer_rows);
		panel.add(new JLabel("columns"), "split 2");
		panel.add(primer_columns, "wrap");
		
		ButtonGroup group = new ButtonGroup();
		group.add(white_primers);
		group.add(brown_primers);
		group.add(black_primers);
		group.add(golden_primers);
		panel.add(white_primers, "split 2");
		panel.add(brown_primers);
		panel.add(black_primers, "split 2");
		panel.add(golden_primers, "wrap");

		panel.add(remove_primer, "left, span, wrap");

		addSeparator(panel, "premium pen");
		panel.add(locate_premiums);
		panel.add(new JLabel("back left chicken eye"), "span 3, wrap");
		panel.add(new JLabel("rows"), "split 2");
		panel.add(premium_rows);
		panel.add(new JLabel("columns"), "split 2");
		panel.add(premium_columns, "wrap");

		addSeparator(panel, "premium colors");
		panel.add(new JLabel("white"), "split 2");
		panel.add(white_premiums);
		panel.add(new JLabel("brown"), "split 2");
		panel.add(brown_premiums, "wrap");
		
		panel.add(new JLabel("black"), "split 2");
		panel.add(black_premiums);
		panel.add(new JLabel("golden"), "split 2");
		panel.add(golden_premiums, "wrap");
		
		addSeparator(panel, "fill in stuff above first");
		panel.add(tend_button);
		JButton stop = new JButton("stop");
		panel.add(stop, "wrap");
		
		panel.add(new JLabel(
			"<html><font color=#0046D5>" +
			"<b>STATUS:  </b>" + 
			"</font></html>  "
			), "left, split 2");
		panel.add(status_message, "left, wrap para");
		
		JLabel stopHelp = new JLabel(
			"<html><font size=-1>" +
			"turn on CAPS LOCK to pause, then click<br />" +
			"<i><b>stop</b></i> or turn off CAPS LOCK to continue" +
			"</font></html>"
			);
		panel.add(stopHelp, "left, span, wrap");
		
		JScrollPane scroller = new JScrollPane(image_area) ;
		scroller.setPreferredSize (new Dimension (880,660));
		panel.add(scroller, "dock east");

		getContentPane().add(panel);
		setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		pack();
	}
	
	private static void addSeparator(JPanel panel, String text) {
		JLabel l = new JLabel(text);
		l.setForeground(accentColor);
		panel.add(l, "gapbottom 1, span, split 2, aligny center, gaptop 10");
		panel.add(new JSeparator(), "gapleft rel, growx, gaptop 10");
	}


	public static void main(String[] args) {
		new OttoFrame().setVisible(true);
	}

}  // class OttoFrame

class ImageArea extends JPanel {
	private static final long serialVersionUID = 2402431474843357440L;

	private Image image;
	private OttoFrame frame;
	
	BasicStroke wideStroke = new BasicStroke(4.0f);
	BasicStroke narrowStroke = new BasicStroke(2.0f);
	
	public ImageArea(OttoFrame frame) {
		super();
		this.frame = frame;
	}
	
	public void paintComponent (Graphics g1) {
		// Repaint the component's background.
		super.paintComponent (g1);
		Graphics2D g = (Graphics2D) g1; 
		
		// If an image has been defined, draw that image using the Component
		// layer of this ImageArea object as the ImageObserver.
		if (image != null)
			g.drawImage (image, 0, 0, this);
		
		drawSpot(g, "farm", frame.farm_location);
		drawSpot(g, "coop", frame.coop_location);
		drawSpot(g, "primers", frame.primer_location);
		drawSpot(g, "premiums", frame.premium_location);
	}

	private void drawSpot(Graphics2D g, String item, Point point) {
		int x = point.x;
		if (0 == x) return;
		int y = point.y;
		int radius = 16;
		int half   = 8;
		
		g.setStroke(wideStroke);
		g.setColor(Color.red) ;
		g.drawOval(x-half, y-half, radius, radius);
		
		// draw an "X" through the circle to mark the center.
		// Maybe just draw a big X instead of the circle?
		g.setStroke(narrowStroke);
		g.drawLine(x+3-half, y+3-half, x+radius-3-half, y+radius-3-half);
		g.drawLine(x+radius-3-half, y+3-half, x+3-half, y+radius-3-half);
		
		// draw a label for the circle
		
		g.setColor(Color.white);
		g.fillRect(x+radius-20, y+radius-6, 80, 16);
		
		g.setColor(Color.blue);
		g.drawString(item, x, y+radius+7);
	}

	
	public void setImage(Image image)
	{
		// Save the image for later repaint.
		this.image = image;

		// Set this panel's preferred size to the image's size, to influence the
		// display of scroll bars.
		setPreferredSize(new Dimension (image.getWidth(this),
				image.getHeight(this)));

		// Present scroll bars as necessary.
		revalidate ();

		// Update the image displayed on the panel.
		repaint ();
	}

}  // class ImageArea