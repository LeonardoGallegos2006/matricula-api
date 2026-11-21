package pe.edu.cibertec.matricula_api.screenplay.questions;

import net.serenitybdd.rest.SerenityRest;
import net.serenitybdd.screenplay.Question;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public class Historial {

    private Historial() {
    }

    public static Question<Integer> creditosAprobados() {
        return actor -> {
            Map<String, Object> historial =
                    SerenityRest.lastResponse().jsonPath().getMap("$");

            Object valor = historial.get("creditosAprobados");

            return ((Number) valor).intValue();
        };
    }

    public static Question<Double> promedioPonderado() {
        return actor -> {
            Map<String, Object> historial =
                    SerenityRest.lastResponse().jsonPath().getMap("$");

            Object valor = historial.get("promedioPonderado");

            return ((Number) valor).doubleValue();
        };
    }

    public static Question<String> condicionDelCurso(String codigoCurso) {
        return actor -> {
            List<Map<String, Object>> cursos =
                    SerenityRest.lastResponse()
                            .jsonPath()
                            .getList("cursos");

            Optional<String> condicion = cursos.stream()
                    .filter(curso -> codigoCurso.equals(
                            String.valueOf(curso.get("codigoCurso"))))
                    .map(curso -> String.valueOf(curso.get("condicion")))
                    .findFirst();

            return condicion.orElse(null);
        };
    }
}