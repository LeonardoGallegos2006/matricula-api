
package pe.edu.cibertec.matricula_api.screenplay.task;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Actor;
import net.serenitybdd.screenplay.Task;
import net.serenitybdd.screenplay.rest.interactions.Get;

import java.util.List;
import java.util.Map;

import static net.serenitybdd.screenplay.Tasks.instrumented;

public class ObtenerIdMatricula implements Task {

    private final String codigoCurso;

    public ObtenerIdMatricula(String codigoCurso) {
        this.codigoCurso = codigoCurso;
    }

    public static ObtenerIdMatricula delCurso(String codigoCurso) {
        return instrumented(ObtenerIdMatricula.class, codigoCurso);
    }

    @Override
    public <T extends Actor> void performAs(T actor) {

        String token = actor.recall("accessToken");

        actor.attemptsTo(
                Get.resource("/api/matriculas")
                        .with(request -> request
                                .header("Authorization", "Bearer " + token))
        );

        if (SerenityRest.lastResponse().statusCode() != 200) {
            throw new AssertionError(
                    "No se pudieron consultar las matrículas. HTTP: "
                            + SerenityRest.lastResponse().statusCode()
            );
        }

        List<Map<String, Object>> matriculas =
                SerenityRest.lastResponse()
                        .jsonPath()
                        .getList("$");

        Integer id = matriculas.stream()
                .filter(m -> codigoCurso.equals(
                        String.valueOf(m.get("codigoCurso"))
                ))
                .map(m -> ((Number) m.get("id")).intValue())
                .findFirst()
                .orElseThrow(() -> new AssertionError(
                        "No existe matrícula para el curso: " + codigoCurso
                ));

        actor.remember("matriculaId", id);
    }
}
