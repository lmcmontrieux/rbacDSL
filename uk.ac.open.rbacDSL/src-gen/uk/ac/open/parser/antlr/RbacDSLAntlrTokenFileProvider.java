/*
* generated by Xtext
*/
package uk.ac.open.parser.antlr;

import java.io.InputStream;
import org.eclipse.xtext.parser.antlr.IAntlrTokenFileProvider;

public class RbacDSLAntlrTokenFileProvider implements IAntlrTokenFileProvider {
	
	public InputStream getAntlrTokenFile() {
		ClassLoader classLoader = getClass().getClassLoader();
    	return classLoader.getResourceAsStream("uk/ac/open/parser/antlr/internal/InternalRbacDSL.tokens");
	}
}