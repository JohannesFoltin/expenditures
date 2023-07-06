import 'package:expenditures/Backend/api/models/day.dart';
import 'package:expenditures/Backend/api/models/expenditure.dart';
import 'package:expenditures/Backend/api/models/trip.dart';
import 'package:expenditures/Backend/repo/repo.dart';
import 'package:expenditures/Frontend/editExpenditure/bloc/edit_expenditure_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditExpenditureView extends StatelessWidget {
  const EditExpenditureView({super.key});

  static Route<void> route({
    required Trip strip,
    required Day day,
    Categories? category,
    Expenditure? expenditure,
  }) {
    return MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => BlocProvider(
              create: (context) => EditExpenditureBloc(
                  repository: context.read<Repo>(),
                  expenditure: expenditure,
                  day: day,
                  trip: strip),
              child: const EditExpenditureView(),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditExpenditureBloc, EditExpenditureState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditExpenditureStateEnum.done,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditExpenditure(),
    );
  }
}

class EditExpenditure extends StatelessWidget {
  const EditExpenditure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditExpenditureBloc, EditExpenditureState>(
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Text("Name: ${state.name}"),
              TextField(
                onChanged: (value) => context
                    .read<EditExpenditureBloc>()
                    .add(NameEdited(newName: value)),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              Text("Beschreibung: ${state.description}"),
              TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (value) => context
                    .read<EditExpenditureBloc>()
                    .add(DescriptionEdited(newDescription: value)),
              ),
              Text("Value: ${state.value}"),
              TextField(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                onChanged: (value) => context
                    .read<EditExpenditureBloc>()
                    .add(ValueEdited(newValue: int.parse(value))),
              ),
              const Text("Direct bezahlt?"),
              Switch(
                value: state.directExpenditure,
                onChanged: (_) => context
                    .read<EditExpenditureBloc>()
                    .add(SwitchedDirectExpenditure()),
              ),
              const Text("Mit Karte bezahlt?"),
              Switch(
                value: state.paidWithCard,
                onChanged: (_) => context
                    .read<EditExpenditureBloc>()
                    .add(SwitchedPayedWithCard()),
              ),
              TextButton(
                onPressed: () {
                  context.read<EditExpenditureBloc>().add(OnSubmitted());
                },
                child: const Text('Submit'),
              )
            ],
          ),
        );
      },
    );
  }
}
