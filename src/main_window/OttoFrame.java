import java.awt.Color;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSeparator;
import javax.swing.JTextField;
import javax.swing.WindowConstants;

import net.miginfocom.swing.MigLayout;

public class OttoFrame extends JFrame {
	private static final long serialVersionUID = 911078009934658231L;

	private JButton capture_farm = new JButton("capture");
    private JLabel capture_progress = new JLabel("ready");
    
	private JButton locate_farm = new JButton("locate");
	private JLabel farm_location = new JLabel("0,0") ;
	
	private JButton locate_coop = new JButton("locate");
	private JLabel coop_location = new JLabel("0,0") ;
	
	private JButton locate_primers = new JButton("locate");
	private JLabel primers_location = new JLabel("0,0") ;
	private JTextField primers_x = new JTextField(3);
	private JTextField primers_y = new JTextField(3);

	private JButton locate_premiums = new JButton("locate");
	private JLabel premiums_location = new JLabel("0,0") ;
	private JTextField premiums_x = new JTextField(3);
	private JTextField premiums_y = new JTextField(3);
	
	private JTextField white_premiums = new JTextField(3);
	private JTextField brown_premiums = new JTextField(3);
	private JTextField black_premiums = new JTextField(3);
	private JTextField golden_premiums = new JTextField(3);
	
	public OttoFrame() {
		this.setTitle("Farmer Otto");
		JPanel panel = new JPanel(new MigLayout("", "[right]"));

		addSeparator(panel, "capture farm");
		panel.add(capture_farm);
		panel.add(capture_progress, "wrap para");
		
		addSeparator(panel, "locate farm");
		panel.add(locate_farm);
		panel.add(farm_location, "wrap para");
	
		addSeparator(panel, "coop");
		panel.add(locate_coop);
		panel.add(coop_location, "wrap para");

		addSeparator(panel, "primer pen");
		panel.add(locate_primers);
		panel.add(primers_location, "wrap");
		panel.add(new JLabel("rows"), "split 2");
		panel.add(primers_x);
		panel.add(new JLabel("cols"), "split 2");
		panel.add(primers_y, "wrap para");
		
		addSeparator(panel, "premium pen");
		panel.add(locate_premiums);
		panel.add(premiums_location, "wrap");
		panel.add(new JLabel("rows"), "split 2");
		panel.add(premiums_x);
		panel.add(new JLabel("cols"), "split 2");
		panel.add(premiums_y, "wrap para");
		
		addSeparator(panel, "premium colors");
		panel.add(new JLabel("white"), "split 2");
		panel.add(white_premiums);
		panel.add(new JLabel("brown"), "split 2");
		panel.add(brown_premiums, "wrap");
		panel.add(new JLabel("black"), "split 2");
		panel.add(black_premiums);
		panel.add(new JLabel("golden"), "split 2");
		panel.add(golden_premiums, "wrap para");
		
		addSeparator(panel, "fill in stuff above first");
		JButton tend = new JButton("tend coop");
		tend.setEnabled(false);
		panel.add(tend);
		JButton stop = new JButton("stop");
		stop.setEnabled(false);
		panel.add(stop, "wrap para");
		panel.add(new JLabel("turn on CAPS LOCK to pause, then click stop"), "span");

		getContentPane().add(panel);
		setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
		pack();
	}
	
	private static void addSeparator(JPanel panel, String text) {
		JLabel l = new JLabel(text);
		l.setForeground(new Color(0, 70, 213));
		panel.add(l, "gapbottom 1, span, split 2, aligny center, gaptop 10");
		panel.add(new JSeparator(), "gapleft rel, growx, gaptop 10");
	}


	public static void main(String[] args)
	{
		new OttoFrame().setVisible(true);
	}

}
