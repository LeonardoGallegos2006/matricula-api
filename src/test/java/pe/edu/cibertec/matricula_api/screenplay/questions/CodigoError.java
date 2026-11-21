
package pe.edu.cibertec.matricula_api.screenplay.questions;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Question;

public class CodigoError {

    public static Question<String> deLaRespuesta() {
        return actor ->
                SerenityRest.lastResponse()
                        .jsonPath()
                        .getString("codigo");
    }
}
