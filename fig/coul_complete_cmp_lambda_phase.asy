import root;
import pad_layout;
include "common_code.asy";

string f_eikonal = topDir + "test_cni_eikonal.root";

string model = "exp3_con";	// doens't matter

string quantities[], q_labels[], q_units[];
real q_abs_mins[], q_abs_maxs[], q_rel_maxs[];
quantities.push("phase"); q_labels.push("\arg F^{\rm C}"); q_units.push(""); q_abs_mins.push(3.0); q_abs_maxs.push(3.15); q_rel_maxs.push(0.001);

xSizeDef = 6.5cm;
ySizeDef = 4.5cm;

xTicksDef = LeftTicks(0.005, 0.001);
yTicksDef = RightTicks(0.05, 0.01);

//----------------------------------------------------------------------------------------------------

real la;

real alpha_eta(real mt)
{
	// TODO
	real al = 1./137;
	return 3.141593 + log(la*la / mt) * al;
}

//----------------------------------------------------------------------------------------------------

for (int qi : quantities.keys)
{
	string quantity = quantities[qi];

	for (int ffi : formFactors.keys)
	{
		NewPad(false);
		label(ff_labels[ffi]);
	}

	NewRow();

	for (int ffi : formFactors.keys)
	{
		NewPad("$|t|\ung{GeV^2}$", "$" + q_labels[qi] + q_units[qi] + "$");
		//scale(Linear, Log);

		for (int lai : lambdas.keys)
		{
			string label = "numerical:" + l_labels[lai];
			//if (lambdas[lai] == lambda_ref)
			//	label += " [ref]";

			pen p = StdPen(lai + 1);

			RootObject g = RootGetObject(f_eikonal, model + "/" + formFactors[ffi] + "/la=" + lambdas[lai] + "/C/g_" + quantity);
			draw(g, p, label);

			la = l_values[lai];
			//if (quantity == "phase" && formFactors[ffi] == "none")
				draw(graph(alpha_eta, 1e-4, 0.02), black+dashed);
		}

		limits((0, q_abs_mins[qi]), (0.02, q_abs_maxs[qi]), Crop);
	}

	AttachLegend(BuildLegend(ymargin=0.5mm));

	/*
	NewRow();

	for (int ffi : formFactors.keys)
	{
		NewPad("$|t|\ung{GeV^2}$", "$(" + q_labels[qi] + " - \hbox{ref}) / \hbox{ref}$");
		//scale(Linear, Log);
		
		RootObject g_ref = RootGetObject(f_eikonal, model + "/" + formFactors[ffi] + "/la=" + lambda_ref + "/C/g_" + quantity);

		for (int lai : lambdas.keys)
		{
			pen p = StdPen(lai + 1);

			RootObject g = RootGetObject(f_eikonal, model + "/" + formFactors[ffi] + "/la=" + lambdas[lai] + "/C/g_" + quantity);
			DrawRel(g, g_ref, p);
		}

		limits((0, -q_rel_maxs[qi]), (0.02, +q_rel_maxs[qi]), Crop);
	}

	AttachLegend();
	*/

	GShipout("coul_complete_cmp_lambda_" + quantity, hSkip=3mm, vSkip=0mm, margin=0mm);
}
