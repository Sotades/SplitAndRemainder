import com.sap.gateway.ip.core.customdev.util.Message
import org.apache.camel.CamelContext
import org.apache.camel.Exchange
import org.apache.camel.impl.DefaultCamelContext
import org.apache.camel.impl.DefaultExchange
// Load Groovy Script
GroovyShell shell = new GroovyShell()
Script script = shell.parse(new File('../../../src/main/groovy/SplitAndRemainder.groovy'))
// Initialize CamelContext and exchange for the message
CamelContext context = new DefaultCamelContext()
Exchange exchange = new DefaultExchange(context)
Message msg = new Message(exchange)
// Initialize the message body with the input file
def body = new File('../../../data/in/Global_Accounting_to_S4.xml')
// Set exchange body in case Type Conversion is required
exchange.getIn().setBody(body)

// Set message headers
msg.setBody(exchange.getIn().getBody())
msg.setHeader('maxitems', 897)
msg.setHeader('maksimierotus', 50000)
msg.setHeader('vastakirjaustili', 290999)
msg.setHeader('kirjauserotili', 320500)
msg.setHeader('erokirjaus_verokoodi', 'VB')
msg.setHeader('split_verokoodi', '')
msg.setHeader('recordsetName', 'Accounting')
msg.setHeader('headerNodeName', 'AccountingHeader')
msg.setHeader('itemNodeName', 'GeneralLedgerAccountItem')

// Execute script
script.processData(msg)
exchange.getIn().setBody(msg.getBody())
// Display results of script in console
println("Body:\r\n${msg.getBody(String)}")
println('Headers:')
msg.getHeaders().each { k, v -> println("$k = $v") }
println('Properties:')
msg.getProperties().each { k, v -> println("$k = $v") }

// Save result to file
def outputFile = new File ('../../../data/out/Global_Accounting_to_S4.xml')
outputFile.write(msg.getBody())
