texpreamble("\SelectNimbusCMFonts\LoadFonts\SetFontSizesVIII");
texpreamble("\def\ung#1{\quad({\rm#1})}");

string topDir = "/afs/cern.ch/work/j/jkaspar/work/software/coulomb_interference_eikonal/";

string models[], m_labels[];
models.push("exp3_con"); m_labels.push("central nuclear amplitude");
models.push("exp3_per"); m_labels.push("peripheral nuclear amplitude");

string lambdas[], l_labels[];
real l_values[];
pen l_pens[];
lambdas.push("1.0E-03"); l_labels.push("$\la = 1\cdot 10^{-3}$"); l_values.push(1.0e-03); l_pens.push(black);
lambdas.push("1.0E-04"); l_labels.push("$\la = 1\cdot 10^{-4}$"); l_values.push(1.0e-04); l_pens.push(red);
lambdas.push("3.0E-05"); l_labels.push("$\la = 3\cdot 10^{-5}$"); l_values.push(3.0e-05); l_pens.push(blue);
lambdas.push("1.0E-05"); l_labels.push("$\la = 1\cdot 10^{-5}$"); l_values.push(1.0e-05); l_pens.push(heavygreen);

string lambda_ref = "3.0E-05";

string formFactors[], ff_labels[];
formFactors.push("none"); ff_labels.push("point-like protons");
formFactors.push("Puckett"); ff_labels.push("realistic proton form-factor (Puckett)");

string formFactor = "Puckett";

//----------------------------------------------------------------------------------------------------

int skipPoint = -1;

void DrawRel(RootObject o, RootObject o_ref, pen p, string label="")
{
	guide g;

	int n = o.iExec("GetN");
	for (int i = 0; i < n; ++i)
	{
		if (i == skipPoint)
			continue;

		real ax[] = {0.};
		real ay[] = {0.};

		o.vExec("GetPoint", i, ax, ay);
		real x = ax[0];
		real y = ay[0];

		real y_ref = o_ref.rExec("Eval", x);

		real y_rel = (y - y_ref) / y_ref;

		g = g--(x, y_rel);
	}

	draw(g, p, label);
}

