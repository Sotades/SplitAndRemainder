import com.sap.gateway.ip.core.customdev.util.Message

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.Properties;


import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


def Message processData(Message message) {
    Reader reader = message.getBody(Reader)
    Writer writer = new StringWriter()

    InputStream inputStream = new ByteArrayInputStream( message.getBody().getBytes() )
    OutputStream outputStream = new ByteArrayOutputStream()


    def headerMap = message.getHeaders()
    int maxItemsPerAccounting = Integer.parseInt((String)headerMap.get("maxitems"))
    int maxDifferenceInTheEnd =Integer.parseInt((String)headerMap.get("maksimierotus"))
    int vastakirjaustili = Integer.parseInt((String)headerMap.get("vastakirjaustili"))
    int kirjauserotili = Integer.parseInt((String)headerMap.get("kirjauserotili"))
    def erokirjaus_verokoodi = headerMap.get("erokirjaus_verokoodi")
    def split_verokoodi = headerMap.get("split_verokoodi")
    def recordsetName = headerMap.get("recordsetName")
    def headerNodeName = headerMap.get("headerNodeName")
    def itemNodeName = headerMap.get("itemNodeName")

    // Create a map to make it easier to pass these variables around
    def configMap = [:]
    configMap.maxItemsPerAccounting = maxItemsPerAccounting
    configMap.maxDifferenceInTheEnd = maxDifferenceInTheEnd
    configMap.vastakirjaustili = vastakirjaustili
    configMap.kirjauserotili = kirjauserotili
    configMap.erokirjaus_verokoodi = erokirjaus_verokoodi
    configMap.split_verokoodi = split_verokoodi
    configMap.recordsetName = recordsetName
    configMap.headerNodeName = headerNodeName
    configMap.itemNodeName = itemNodeName




    execute(inputStream, outputStream, configMap)

    //String finalString = new String(outputStream.toByteArray());
    String finalString = new String(outputStream.toString())

    message.setBody(finalString)

    return message
}

//Makes empty node
public static Node CopyAndMakeEmptyNode(Document sourceDocument, Node sourceNode){
    sourceDocument.appendChild(sourceDocument.adoptNode(sourceNode.cloneNode(true)));
    Node modifiedNode = sourceDocument.getFirstChild();
    while (modifiedNode.hasChildNodes()) {
        modifiedNode.removeChild(modifiedNode.getFirstChild());
    }
    return modifiedNode;
}

//Removes nodes which contains text mentioned in the arguments from named nodes
public static NodeList RemoveChildElementsContainingSomeText(Document sourceDocument, String parentNodeName, String childNodeName, String text){
    //Remove ChildElements which contain something about "jakotili" in certain node
    NodeList itemNodeListModified = sourceDocument.getElementsByTagName(parentNodeName);
    int amountOfChildsSource = itemNodeListModified.getLength();
    int indexOfChildNode = 0;
    for(int i = 0; i < amountOfChildsSource; i++){
        indexOfChildNode = GetGenericIndexFromNode(itemNodeListModified,i, childNodeName);
        if(itemNodeListModified.item(i).getChildNodes().item(indexOfChildNode).getTextContent().contains(text)){
            itemNodeListModified.item(i).getParentNode().removeChild(itemNodeListModified.item(i));
            i--;
            amountOfChildsSource--;
        }
    }
    return itemNodeListModified;
}

//Append node
public static Node AppendNodeByChildNode(Document parentNodeSource, Node parentNode, Node childNode, int amountOfChildNodes){
    for (int i = 0; i < amountOfChildNodes; i++) {
        Node copyOfchild = parentNodeSource.importNode(childNode, true);
        parentNode.appendChild(copyOfchild);
    }
    return parentNode;
}

//This function gets an index of a certain child node from certain item by defined String fieldName
public static int GetGenericIndexFromNode(NodeList nlItem, int currentIndex, String fieldName){

    int fieldNameIndex = 0;
    for(int i = 0; i < nlItem.item(currentIndex).getChildNodes().getLength(); i++){
        try{
            if(nlItem.item(currentIndex).getChildNodes().item(i).getNodeName()==fieldName){
                fieldNameIndex = i;
                i = nlItem.item(currentIndex).getChildNodes().getLength() +1; //Break the loop
            }

        }catch(Exception e){
            //Makes and error when the specified element is not found, not critical
        }
    }
    return fieldNameIndex;

}

//Get Sign index from the node. Sign defines whether + or - operation is used
public static int GetSignIndexFromNode(NodeList nlItem, int currentIndex){
    int signIndex = 0;
    for(int i = 0; i < nlItem.item(currentIndex).getChildNodes().getLength(); i++){
        try{
            if(nlItem.item(currentIndex).getChildNodes().item(i).getAttributes().getNamedItem("Sign")!=null){
                signIndex = i;
                i = nlItem.item(0).getChildNodes().getLength() +1;
            }

        }catch(Exception e){
            //Nothing to do here. "Sign" is there
        }
    }
    return signIndex;

}

//Define what sign means, Sign defines whether + or - operation is used
public static char GetSignFromNode(NodeList nodel, int nodei, int signi){
    String signS = (nodel.item(nodei).getChildNodes().item(signi).getAttributes().getNamedItem("Sign").getNodeValue());
    char signC = 'n';
    if(signS == ""){
        signC = '+';
    }
    else{
        signC = signS.charAt(0);
    }
    return signC;
}

/*Use this form when making GeneralLedgerItem as vastakirjaustili or for debet&credit difference
 *
 * <alma:GeneralLedgerAccountItem>
			<alma:ItemNo>xxx</alma:ItemNo> //This is either 1 or last index of GeneralLedgerItems
			<alma:ItemText>Liittymaineiston jako, vastakirjaus</alma:ItemText>
			<alma:Account>*vastakirjaustili*</alma:Account> //This is to be defined
			<alma:DocumentValue
				Currency="EUR"
				Sign="S">VVVVV</alma:DocumentValue>
		</alma:GeneralLedgerAccountItem>
 */
public static Node CreateVastakirjausNode(Node vkNode, int kirjaustili, int index, double value, String namespaceInSource, String verokoodi, String reason){

    Node modifiedNode = vkNode;
    String sign = "";

    if(index == 1){
        if(value < 0){
            sign = "-";
        }else{
            sign = "+";
        }
    }
    else{
        if(value < 0){
            sign = "+";
        }else{
            sign = "-";
        }

    }

    value = Math.abs(value); //Sign defines if it is + or -
    for(int i = 0; i < vkNode.getChildNodes().getLength(); i++){

        if(vkNode.getChildNodes().item(i).getNodeName().contains((namespaceInSource+"ItemNo"))){
            vkNode.getChildNodes().item(i).setTextContent(Integer.toString(index));
        }
        else if(vkNode.getChildNodes().item(i).getNodeName().contains((namespaceInSource+"ItemText"))){
            vkNode.getChildNodes().item(i).setTextContent(reason);

        }
        else if(vkNode.getChildNodes().item(i).getNodeName().contains(namespaceInSource+"Account")){
            vkNode.getChildNodes().item(i).setTextContent(Integer.toString(kirjaustili));
        }
        else if(vkNode.getChildNodes().item(i).getNodeName().contains(namespaceInSource+"DocumentValue")){
            String sValue = String.valueOf((long) value/100.00);
            vkNode.getChildNodes().item(i).setTextContent(sValue);
            vkNode.getChildNodes().item(i).getAttributes().getNamedItem("Sign").setNodeValue(sign);
        }
        else if(vkNode.getChildNodes().item(i).getNodeName().contains(namespaceInSource+"TaxCode")){
            vkNode.getChildNodes().item(i).setTextContent(verokoodi);
        }
        else{
            //Remove useless nodes which are not related to the use of Vastakirjaustili-node
            vkNode.getChildNodes().item(i).getParentNode().removeChild(vkNode.getChildNodes().item(i));
            i--;
        }
    }
    return modifiedNode;
}

//Set the correct Index for the element
public static Node SetCorrectIndex(Node inNode, int index, String namespaceInSource){

    Node modifiedNode = inNode;
    for(int i = 0; i < inNode.getChildNodes().getLength(); i++){

        if(inNode.getChildNodes().item(i).getNodeName().contains((namespaceInSource+"ItemNo"))){
            inNode.getChildNodes().item(i).setTextContent(Integer.toString(index));
        }
    }
    return modifiedNode;

}

public static Boolean CheckSums(double sum, int maxDiff){
    boolean match = false;
    System.out.println("Max allowed " + maxDiff + " Current Diff " + sum);
    System.out.println(-maxDiff  +" < "+ sum + " && " + sum + " < " + maxDiff);
    if(-maxDiff < sum && sum < maxDiff){
        match = true;
    }
    return match;

}

public static void HandleXML(Document docSource, OutputStream outStream, Map configMap) {

    //Configurations
    int maxItemsPerAccounting = 0; //Change this value as needed, 999 is technical limit for IDoc
    int vastakirjaustili = 0; //Split account
    int kirjauserotili = 0;
    String erokirjaus_verokoodi = "";
    String split_verokoodi = "";
    int maxDifferenceInTheEnd = 0;  //Credit/Debit maybe +/- this sum and it is okay
    String recordsetName = "";
    String headerNodeName = "";
    String itemNodeName = "";


    //Read the config file and assign the configurations
    //FileInputStream fis = null;
    //Properties prop = new Properties();
    //fis = new FileInputStream("C:\\Users\\Tony\\Downloads\\sap-press-cpi-groovy-testing\\src\\main\\groovy\\config.properties");
    //InputStream input = SplitAndAllowDifferences.class.getResourceAsStream("config.properties");


    try {
        //prop.load(fis);
        maxItemsPerAccounting = configMap.maxItemsPerAccounting
        maxDifferenceInTheEnd = configMap.maxDifferenceInTheEnd
        vastakirjaustili = configMap.vastakirjaustili
        kirjauserotili = configMap.kirjauserotili
        erokirjaus_verokoodi = configMap.erokirjaus_verokoodi
        split_verokoodi = configMap.split_verokoodi
        recordsetName = configMap.recordsetName
        headerNodeName = configMap.headerNodeName
        itemNodeName = configMap.itemNodeName


    } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }



    int amountOfItemsInSource = 0; //How many items are in the Accounting-node, not including the Header(s)
    String namespaceInSource = "";
    try {

        //Create DocumentBuilderFactory and DocumentBuilder for making XML-data
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

        //Make docTarget which is used as the result of the splitting
        //Make docAccounting and docHeader as temperature "variables"
        Document docTarget = docBuilder.newDocument();
        Document docAccounting = docBuilder.newDocument();

        // Get the Root Node
        Node RootSource = docSource.getFirstChild();



        // Get the namespace from source
        int nonWhiteSpaceIndex = 0;
        while(true){

            if(docSource.getDocumentElement().getChildNodes().item(nonWhiteSpaceIndex).getNodeName().contains("#")){
                nonWhiteSpaceIndex++;
            }else{
                namespaceInSource =  docSource.getDocumentElement().getChildNodes().item(nonWhiteSpaceIndex).getNodeName();
                //namespaceInSource = (namespaceInSource.split(":"))[0];

                if(namespaceInSource.split(":").length < 2){
                    namespaceInSource = "";
                }
                else{
                    namespaceInSource = (namespaceInSource.split(":"))[0] + ":";
                }

                break;
            }

        }


        Node AccountingSource = docSource.getElementsByTagName(namespaceInSource+recordsetName).item(0);

        // Get the AccountingHeader element by tag name directly, it can be reused as is in every Account node
        Node AccountingHeader = docSource.getElementsByTagName(namespaceInSource+headerNodeName).item(0);

        //Make RootNode and AccountingNode as empty nodes to be used
        Node RootNode = CopyAndMakeEmptyNode(docTarget, RootSource);
        Node AccountingNode = CopyAndMakeEmptyNode(docAccounting, AccountingSource);


        //Remove ChildNodes which contain something about jakotili in certain element
        NodeList itemNodeList = RemoveChildElementsContainingSomeText(docSource, namespaceInSource+itemNodeName, namespaceInSource+"ItemText", "vastakirjaus");
        amountOfItemsInSource = itemNodeList.getLength();

        // Calculate how many Accounting nodes are needed, if maxItemsPerAccounting sets the limit. +1 to make sure there are enough Accounting Elements
        int amountOfAccounting = (int) Math.ceil((double) (amountOfItemsInSource) / (maxItemsPerAccounting));
        //System.out.println(amountOfAccounting);
        amountOfAccounting = amountOfAccounting*2; //Makes sure there are enough Accounting elements
        AppendNodeByChildNode(docTarget, RootNode, AccountingNode, amountOfAccounting);


        //ALL FUNCTIONALITY IS BASICALLY HERE

        //Variables used within the While-loop
        NodeList accountingNodeList = docTarget.getElementsByTagName(namespaceInSource+recordsetName);
        boolean accountsNeeded = true; //Keep adding data if true
        int itemNoInCurrentAccounting = 1; //Each Accounting contains Items which have ItemNo value varying from 1 to maxItemsPerAccounting or less.
        boolean addVastakirjaustili = false; //This is used in the beginning of Accounting-node, if previous Accounting-node ended as non-zero value
        long sumvalue = 0; //Keeps track that sum of the items is zero in the end. If not, then there is an error. 0.01 and 0.02 is acceptable error
        long tempValue = 0;
        int accountNoIndex = 0; //What iteration of accounts is going on
        int itemListIndex = 0; //Keeps track on items on itemlist, reaches the maximum amount of GeneralLedgerAccountItem amount
        int signIndex = 0;


        while(accountsNeeded){
            itemNoInCurrentAccounting = 1;
            //Append first Accounting-node with Header-node
            AppendNodeByChildNode(docTarget, accountingNodeList.item(accountNoIndex), AccountingHeader, 1);

            //append Accounting node with Item-nodes
            for (int j = 0; j < maxItemsPerAccounting; j++) {

                //If previous Accounting-node ended with using Vastakirjaustili, the next one should use Vastakirjaustili on its first Item-node
                //TODO should the itemnro should 1 ONLY if vastakirjaustili is the first element?
                if(addVastakirjaustili){
                    Node copyOfI = docTarget.importNode(itemNodeList.item(0), true);
                    copyOfI = CreateVastakirjausNode(copyOfI, vastakirjaustili, itemNoInCurrentAccounting, sumvalue, namespaceInSource, split_verokoodi, "Vastakirjaus");
                    accountingNodeList.item(accountNoIndex).appendChild(copyOfI);
                    addVastakirjaustili = false; //Set to false, so it is not used on every iteration
                    itemNoInCurrentAccounting++;
                }//ENDIF


                //Keep track of the sum from the Items
                if (itemNodeList.item(itemListIndex) != null) {

                    //Append with Item
                    signIndex =  GetSignIndexFromNode(itemNodeList, itemListIndex);
                    Node copyOfI = docTarget.importNode(itemNodeList.item(itemListIndex), true);
                    copyOfI = SetCorrectIndex(copyOfI, itemNoInCurrentAccounting, namespaceInSource);
                    accountingNodeList.item(accountNoIndex).appendChild(copyOfI);
                    //tempValue = Double.parseDouble(itemNodeList.item(itemListIndex).getChildNodes().item(signIndex).getTextContent())*100;
                    double tempValue_d = Double.parseDouble(itemNodeList.item(itemListIndex).getChildNodes().item(signIndex).getTextContent())*100;
                    tempValue = (long)Math.floor(tempValue_d + 0.5d);
                    //System.out.print(Double.parseDouble(itemNodeList.item(itemListIndex).getChildNodes().item(signIndex).getTextContent()) +" ");
                    //System.out.print(itemNodeList.item(itemListIndex).getChildNodes().item(signIndex).getTextContent() + "  ");
                    //System.out.println(tempValue);
                    // Read Value and sign and do the operation sign tells, + or - . Track Value in case of splitting and using Vastakirjaustili
                    //Multiply by 100, so value can be Handled as integer, precision of data is 0.00 (two digits)
                    //Define if it is plus or minus operation by its sign
                    char sign = GetSignFromNode(itemNodeList,itemListIndex, signIndex);
                    if (sign == '+') {
                        sumvalue = sumvalue + tempValue;

                    } else {
                        sumvalue = sumvalue - tempValue;
                    }

                    itemListIndex++; //Item added and handled
                    itemNoInCurrentAccounting++;
                } //ENDIF
            }//ENDFOR
            //System.out.println(sumvalue);




            //Check if sums match for IDoc. If it is non-zero value, add Item with vastakirjaustili
            if(sumvalue != 0){
                addVastakirjaustili = true; //This is used in the beginning of next Accounting
                Node copyOfI = docTarget.importNode(itemNodeList.item(0), true);

                //Check if element is last for the IDoc, then add kirjaueserotili, to balance debet/credit
                if(itemListIndex < itemNodeList.getLength()){
                    copyOfI = CreateVastakirjausNode(copyOfI, vastakirjaustili, itemNoInCurrentAccounting, sumvalue, namespaceInSource, split_verokoodi, "Vastakirjaus");
                }
                else{
                    copyOfI = CreateVastakirjausNode(copyOfI, kirjauserotili, itemNoInCurrentAccounting, sumvalue, namespaceInSource, erokirjaus_verokoodi, "Kirjausero");
                    System.out.println("Debet/credit difference " + sumvalue);
                }
                accountingNodeList.item(accountNoIndex).appendChild(copyOfI);
            }

            //Check if all the Items have been iterated or not
            if(itemListIndex < itemNodeList.getLength()){
                accountsNeeded = true;
                accountNoIndex++;
            }else{
                accountsNeeded = false;
            }

        }//END while(accountsNeeded)

        //Clean document from un-used Accounting-nodes
        for(int i = accountingNodeList.getLength()-1; i > 0; i--){
            if(accountingNodeList.item(i).getChildNodes().getLength() == 0){
                RootNode.removeChild(accountingNodeList.item(i));
            }

        }

        //Used to write message out
        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer t = tf.newTransformer();


        //If sums match, write modified XML for next mapping, else write the original, and error will occur

        if(CheckSums(sumvalue, maxDifferenceInTheEnd)){
            t.transform(new DOMSource(docTarget), new StreamResult(outStream));
            System.out.println("OKAY");
        }
        else{
            t.transform(new DOMSource(docSource), new StreamResult(outStream));
            System.out.println("NOT OKAY");

        }

        System.out.println("Done");




    } catch (ParserConfigurationException pce) {
        pce.printStackTrace();
    } catch (TransformerException tfe) {
        tfe.printStackTrace();
    }
}

//This is called either by transform or by main function. It takes the source stream and makes the Document to be processed
public void execute(InputStream inputStream, OutputStream outputStream, Map configMap) throws TransformerException {
    try {

        //Make the XML-document from inputStream
        DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
        Document docSource = docBuilder.parse(inputStream);
        HandleXML(docSource, outputStream, configMap);

    } catch (Exception exception) {
        // getTrace().addDebugMessage(exception.getMessage());
        throw new TransformerException(exception.toString());
    }
}

