
import java.io.FileReader;
import java.io.PrintWriter;
import mulan.classifier.MultiLabelOutput;
import mulan.classifier.meta.RAkEL;
import mulan.classifier.transformation.LabelPowerset;
import mulan.data.MultiLabelInstances;
import mulan.classifier.meta.HOMER;
import mulan.classifier.meta.HierarchyBuilder;
import weka.classifiers.trees.J48;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.Utils;
import mulan.classifier.transformation.CalibratedLabelRanking;

public class HOMERModel {

    public static void main(String[] args) throws Exception {
        String arffFilename = Utils.getOption("arff", args);
        String xmlFilename = Utils.getOption("xml", args);
	String outputFilename = Utils.getOption("output", args);
	String scoresFilename = Utils.getOption("scores", args);

        MultiLabelInstances dataset = new MultiLabelInstances(arffFilename, xmlFilename);

        HOMER model = new HOMER(new CalibratedLabelRanking(new J48()),4,HierarchyBuilder.Method.BalancedClustering);

        model.build(dataset);


        String unlabeledFilename = Utils.getOption("unlabeled", args);
        FileReader reader = new FileReader(unlabeledFilename);
        Instances unlabeledData = new Instances(reader);

        int numInstances = unlabeledData.numInstances();

	PrintWriter writer = new PrintWriter(outputFilename, "UTF-8");
	PrintWriter writer2 = new PrintWriter(scoresFilename, "UTF-8");

        for (int instanceIndex = 0; instanceIndex < numInstances; instanceIndex++) {
            Instance instance = unlabeledData.instance(instanceIndex);
            MultiLabelOutput output = model.makePrediction(instance);
            // do necessary operations with provided prediction output, here just print it out
	    boolean[] predictions = output.getBipartition();
	    for (int i = 0; i < predictions.length; i++){
		int prediction = predictions[i] ? 1 : 0;
            	writer.print(prediction);
		writer.print(" ");
	    }
	    writer.println("");
	    double[] scores = output.getConfidences();
	    for (int i = 0; i < scores.length; i++){
            	writer2.print(scores[i]);
		writer2.print(" ");
	    }
	    writer2.println("");
        }

	writer.close();
	writer2.close();
    }
}

