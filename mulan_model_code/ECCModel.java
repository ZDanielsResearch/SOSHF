
import java.io.FileReader;
import java.io.PrintWriter;
import mulan.classifier.MultiLabelOutput;
import mulan.classifier.meta.RAkEL;
import mulan.classifier.transformation.LabelPowerset;
import mulan.data.MultiLabelInstances;
import mulan.classifier.transformation.EnsembleOfClassifierChains;
import weka.classifiers.trees.J48;
import weka.core.Instance;
import weka.core.Instances;
import weka.core.Utils;

public class ECCModel {

    public static void main(String[] args) throws Exception {
        String arffFilename = Utils.getOption("arff", args);
        String xmlFilename = Utils.getOption("xml", args);
	String outputFilename = Utils.getOption("output", args);

        MultiLabelInstances dataset = new MultiLabelInstances(arffFilename, xmlFilename);

        EnsembleOfClassifierChains model = new EnsembleOfClassifierChains();

        model.build(dataset);


        String unlabeledFilename = Utils.getOption("unlabeled", args);
        FileReader reader = new FileReader(unlabeledFilename);
        Instances unlabeledData = new Instances(reader);

        int numInstances = unlabeledData.numInstances();

	PrintWriter writer = new PrintWriter(outputFilename, "UTF-8");

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
        }

	writer.close();
    }
}

