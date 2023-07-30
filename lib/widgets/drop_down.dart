import 'package:chat_gpt_clone/constants/constants.dart';
import 'package:chat_gpt_clone/models/model.dart';
import 'package:chat_gpt_clone/providers/models_provider.dart';
import 'package:chat_gpt_clone/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelsDropDownWidget extends StatefulWidget {
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState() => _ModelsDropDownWidgetState();
}

class _ModelsDropDownWidgetState extends State<ModelsDropDownWidget> {
  @override
  void initState() {
    Provider.of<ModelsProvider>(context, listen: false).getAllModels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return modelsProvider.getModelList().isEmpty
        ? FutureBuilder<List<Model>>(
            future: modelsProvider.getAllModels(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const SizedBox.shrink();
              }
              return FittedBox(
                child: DropdownButton(
                    dropdownColor: scaffoldBackGroundColor,
                    value: modelsProvider.currentModel,
                    items: List<DropdownMenuItem<String>>.generate(
                        snapshot.data!.length,
                        (index) => DropdownMenuItem(
                              value: snapshot.data![index].id,
                              child: TextWidget(
                                  label: snapshot.data![index].id,
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                    onChanged: (value) {
                      setState(() {
                        modelsProvider.setCurrentModel(value!);
                      });
                    }),
              );
            })
        : FittedBox(
            child: DropdownButton(
                dropdownColor: scaffoldBackGroundColor,
                value: modelsProvider.currentModel,
                items: List<DropdownMenuItem<String>>.generate(
                    modelsProvider.getModelList().length,
                    (index) => DropdownMenuItem(
                          value: modelsProvider.getModelList()[index].id,
                          child: TextWidget(
                              label: modelsProvider.getModelList()[index].id,
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                onChanged: (value) {
                  setState(() {
                    modelsProvider.setCurrentModel(value!);
                  });
                }),
          );
  }
}
