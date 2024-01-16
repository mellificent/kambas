import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kambas/widgets/textfield/TextFieldStyle2.dart';

import '../widgets/textfield/TextFieldStyle1.dart';

mixin FormMixins<B extends Bloc<dynamic, S>, S> {
  Widget buildFlexTextFieldStyle1(
    BuildContext context, {
    required String id,
    Function(String)? onValueChange,
    required bool Function(String, S, S) buildWhen,
    required TextFieldStyle1 Function(BuildContext, S, TextEditingController)
        builder,
    TextEditingController? controller,
  }) {
    TextEditingController textedit = controller ?? TextEditingController();
    textedit.addListener(() {
      if (onValueChange != null) {
        onValueChange.call(textedit.text);
      }
    });

    return BlocBuilder<B, S>(
      buildWhen: (previous, current) => buildWhen.call(id, previous, current),
      builder: (BuildContext context, state) =>
          builder.call(context, state, textedit),
    );
  }

  Widget buildFlexTextFieldStyle2(
      BuildContext context, {
        required String id,
        Function(String)? onValueChange,
        required bool Function(String, S, S) buildWhen,
        required TextFieldStyle2 Function(BuildContext, S, TextEditingController)
        builder,
        TextEditingController? controller,
      }) {
    TextEditingController textedit = controller ?? TextEditingController();
    textedit.addListener(() {
      if (onValueChange != null) {
        onValueChange.call(textedit.text);
      }
    });

    return BlocBuilder<B, S>(
      buildWhen: (previous, current) => buildWhen.call(id, previous, current),
      builder: (BuildContext context, state) =>
          builder.call(context, state, textedit),
    );
  }

  Widget buildWidget(
    BuildContext context, {
    required String id,
    required bool Function(String, S, S) buildWhen,
    Widget Function(BuildContext, S)? builder,
    Widget Function(BuildContext, S, String)? builderWithID,
  }) {
    return BlocBuilder<B, S>(
      buildWhen: (previous, current) => buildWhen.call(id, previous, current),
      builder: (BuildContext context, state) => (builder != null)
          ? builder.call(context, state)
          : builderWithID!.call(context, state, id),
    );
  }

}
