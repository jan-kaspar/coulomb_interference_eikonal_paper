import root;
import pad_layout;
include "common_code.asy";

string f_eikonal = topDir + "test_cni_eikonal.root";

xSizeDef = 6.5cm;
ySizeDef = 4.5cm;

xTicksDef = LeftTicks(0.005, 0.001);

//----------------------------------------------------------------------------------------------------

/*
NewRow();

for (int mi : models.keys)
{
	NewPad("$|t|\ung{GeV^2}$", "$\d\sigma/\d t\ung{mb/GeV^2}$");
	//scale(Linear, Log);

	for (int lai : lambdas.keys)
	{
		string label = l_labels[lai];
		if (label == lambda_ref)
			label += " [ref]";

		draw(RootGetObject(f_eikonal, models[mi] + "/" + formFactor + "/la=" + lambdas[lai] + "/CH/g_dsdt"), l_pens[lai], label);
	}

	limits((0, 300), (0.02, 1000), Crop);
}

AttachLegend();
*/

NewRow();

frame f_legend;

for (int mi : models.keys)
{
	NewRow();

	NewPad("$|t|\ung{GeV^2}$", "$(\d\sigma^{\rm C+N}/\d t - \hbox{ref}) / \hbox{ref}$");
	//scale(Linear, Log);

	for (int lai : lambdas.keys)
	{
		string label = "numerical: " + l_labels[lai];
		if (lambdas[lai] == lambda_ref)
			label += " [ref]";

		RootObject obj = RootGetObject(f_eikonal, models[mi] + "/" + formFactor + "/la=" + lambdas[lai] + "/CH/g_dsdt");
		RootObject obj_ref = RootGetObject(f_eikonal, models[mi] + "/" + formFactor + "/la=" + lambda_ref + "/CH/g_dsdt");

		if (lambdas[lai] == "1.0E-05")
			skipPoint = 156;
		else
			skipPoint = -1;

		DrawRel(obj, obj_ref, l_pens[lai], label);
	}

	limits((0, -0.0005), (0.02, 0.001), Crop);

	f_legend = BuildLegend(ymargin=0mm);

	currentpicture.legend.delete();

	AttachLegend(shift(0, 1) * BuildLegend(m_labels[mi], S, framePen=nullpen), N);
}

AttachLegend(f_legend);

GShipout(hSkip=3mm, vSkip=0mm, margin=0mm);
