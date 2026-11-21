
package pe.edu.cibertec.matricula_api.screenplay.task;

import io.restassured.http.ContentType;

import net.serenitybdd.annotations.Step;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Patch;

import java.util.HashMap;
import java.util.Map;

import static net.serenitybdd.screenplay.Tasks.instrumented;

public class CalificarMatricula implements Task {

    private final int idMatricula;
    private final double nota;

    public CalificarMatricula(int idMatricula, double nota) {
        this.idMatricula = idMatricula;
        this.nota = nota;
    }

    public static CalificarMatricula conIdYNota(
            int idMatricula, double nota) {
        return instrumented(
                CalificarMatricula.class,
                idMatricula,
                nota
        );
    }

    @Override
    @Step("{0} registra la calificación #nota")
    public <T extends Actor> void performAs(T actor) {

        String token = actor.recall("accessToken");

        Map<String, Object> datos = new HashMap<>();
        datos.put("nota", nota);

        actor.attemptsTo(
                Patch.to("/api/matriculas/{id}/nota")
                        .with(request -> request
                                .header("Authorization", "Bearer " + token)
                                .contentType(ContentType.JSON)
                                .pathParam("id", idMatricula)
                                .body(datos))
        );
    }
}
