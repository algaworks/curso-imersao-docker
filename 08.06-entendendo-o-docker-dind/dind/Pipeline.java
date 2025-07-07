public class Pipeline {

    public static void main(String[] args) {
        System.out.println("Aplicacao Java Pipeline com Docker DinD");
        System.out.println("Aplicacao Java em execucao...");
   
        for (int i = 1; i <= 5; i++) {
            System.out.println("Processando item " + i + " /5");
        }

        System.out.println("Processamento concluido!");
    }
    
}
