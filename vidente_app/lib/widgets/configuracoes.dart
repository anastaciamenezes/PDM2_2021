//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vidente_app/controllers/cidade_controller.dart';
import 'package:vidente_app/controllers/tema_controller.dart';
import 'package:vidente_app/models/cidade.dart';
import 'package:vidente_app/services/cidade_service.dart';
//import 'package:vidente_app/models/previsao_hora.dart';
//import 'package:vidente_app/services/previsao_service.dart';
//import 'package:vidente_app/widgets/configuracoes.dart';
//import 'package:vidente_app/widgets/proximas_temperaturas.dart';
//import 'package:vidente_app/widgets/resumo.dart';

/**class Home extends StatefulWidget {
* @override
*_HomeState createState() => _HomeState();
}*/

class Configuracoes extends StatefulWidget {
   @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

/**class _HomeState extends State<Home> {
*  Future<List<PrevisaoHora>> ultimasPrevisoes;
*  Future<List<Cidade>> cidades;
**/

class _ConfiguracoesState extends State<Configuracoes> {
  List<Cidade> cidades;
  bool carregandoCidades;
  String filtro;
  final TextEditingController _controller = TextEditingController();

  var ultimasCidades;  

  @override
  void initState() {
    super.initState();
    carregarCidades();
    //carregarPrevisoes();
    this.carregandoCidades = false;
    this.filtro = "";
  }

  void carregarCidades() {
  //void carregarPrevisoes() {
    CidadeService service = CidadeService();
    //PrevisaoService service = PrevisaoService();
    ultimasCidades = service.recuperarUltimasCidades();
    //ultimasPrevisoes = service.recuperarUltimasPrevisoes();
  }
  //Usando o Iterable um elemento ou uma coleção podem ser acessados sequencialmente. 
  Iterable<Cidade> filtrarCidades(String consulta) {
    return this.cidades.where(
        (cidade) => cidade.nome.toLowerCase().contains(consulta.toLowerCase()));
 
  /**Future<Null> atualizarPrevisoes() async {
   * setState(() => carregarPrevisoes());}
   */
// ignore: dead_code
@override
  Widget build(BuildContext context) {
    bool suaCidadeEscolhida =
        CidadeController.instancia.cidadeEscolhida != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            suaCidadeEscolhida ? "Configurações" : "Escolher cidade"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Icon(Icons.brightness_6_outlined),
                    Switch(
                      value: TemaController.instancia.usarTemaEscuro,
                      onChanged: (valor) {
                        TemaController.instancia.trocarTema();
                      },
                    ),
                  ],
                ),
              ],
            ),
            TypeAheadField<Cidade>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: this._controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: "Buscar cidade",
                ),
              ),
              suggestionsCallback: filtrarCidades,
              onSuggestionSelected: (sugestao) async {
                setState(() {
                  this.filtro = sugestao.nome + " " + sugestao.estado;
                  this._controller.text = filtro;
                });
              },
              itemBuilder: (context, sugestao) {
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(sugestao.nome + " - " + sugestao.siglaEstado),
                  subtitle: Text(sugestao.estado),
                );
              },
              noItemsFoundBuilder: (context) => Container(
                child: Center(
                  child: Text(
                    'Nenhuma cidade encontrada',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            this.filtro != ""
                ? ElevatedButton(
                    onPressed: () async {
                      CidadeService service = CidadeService();
                      service.buscarCidade(filtro).then(
                          (resultado) => Navigator.pushNamed(context, '/home'));
                      setState(() {
                        this.carregandoCidades = true;
                      });
                    },
                    child: Text(
                      "Salvar Configurações",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Text(""),
            this.carregandoCidades
                ? Column(
                    children: [
                      Padding(padding: EdgeInsets.all(20)),
                      Image(
                        image: AssetImage('images/loading.gif'),
                        width: 50,
                      )
                    ],
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    throw UnimplementedError();
  }  
}