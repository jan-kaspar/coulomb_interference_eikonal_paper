import root;
import pad_layout;
include "common_code.asy";

string f_elegent = topDir + "test_cni_elegent.root";

string f_eikonal = topDir + "test_cni_eikonal.root";

string model = "exp3_con";	// doens't matter

string quantities[], q_labels[], q_units[];
real q_abs_mins[], q_abs_maxs[], q_rel_maxs[];
quantities.push("dsdt"); q_labels.push("\d\sigma^{\rm C}/\d t"); q_units.push("\ung{mb/GeV^2}"); q_abs_mins.push(0.); q_abs_maxs.push(600.); q_rel_maxs.push(0.001);

xSizeDef = 6.5cm;
ySizeDef = 4.5cm;
xTicksDef = LeftTicks(0.005, 0.001);

//----------------------------------------------------------------------------------------------------

for (int qi : quantities.keys)
{
	string quantity = quantities[qi];

	frame f_legend;

	for (int ffi : formFactors.keys)
	{
		NewRow();

		NewPad("$|t|\ung{GeV^2}$", "$(" + q_labels[qi] + " - \hbox{ref}) / \hbox{ref}$");
		//scale(Linear, Log);
		
		//RootObject g_ref = RootGetObject(f_eikonal, model + "/" + formFactors[ffi] + "/la=" + lambda_ref + "/C/g_" + quantity);
		RootObject g_ref = RootGetObject(f_elegent, model + "/coulomb/" + formFactors[ffi] + "/g_dsdt");

		for (int lai : lambdas.keys)
		{
			string label = "numerical: " + l_labels[lai];

			RootObject g = RootGetObject(f_eikonal, model + "/" + formFactors[ffi] + "/la=" + lambdas[lai] + "/C/g_" + quantity);
			DrawRel(g, g_ref, l_pens[lai], label);
		}

		limits((0, -0.0005), (0.02, +q_rel_maxs[qi]), Crop);

		f_legend = BuildLegend();

		currentpicture.legend.delete();

		AttachLegend(shift(0, 1) * BuildLegend(ff_labels[ffi], S, framePen=nullpen), N);
	}

	draw((0, 0)--(0.02, 0.), dashed, "Born ($\la = 0$) [ref]");

	AttachLegend(f_legend);

	GShipout("coul_complete_cmp_lambda_" + quantity, hSkip=3mm, vSkip=0mm);
}
