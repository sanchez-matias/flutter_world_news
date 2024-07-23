import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  final List<int> selectedTagsIds = [];
  TextEditingController tagNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TagsCubit>().getTags();
  }

  @override
  void dispose() {
    tagNameController.dispose();
    super.dispose();
  }

  Future<String?> showNameInputDialog({String? previousName}) async {
    if (previousName != null) {
      tagNameController.text = previousName;
    }

    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tag Name'),
        content: TextField(
          controller: tagNameController,
          onChanged: (value) {
            tagNameController.text = value;
          },
        ),
        actions: [
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop(tagNameController.text);
              tagNameController.text = '';
            },
            label: const Text('Save'),
            icon: const Icon(Icons.save),
          )
        ],
      ),
    );
  }

  Future<bool> areYouSureDialog() async {
    bool answer = false;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Once you delete your tags,'
            ' you will not be able to recover them.'),
        actions: [
          FilledButton(
              onPressed: () {
                answer = true;
                Navigator.of(context).pop();
              },
              child: const Text('I am sure')),
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
        ],
      ),
    );

    return answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lists'),
        actions: [
          IconButton(
            onPressed: () async {
              final name = await showNameInputDialog();
              if (name == null || !context.mounted) return;
              context.read<TagsCubit>().createTag(name);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: selectedTagsIds.isEmpty
                ? null
                : () async {
                    final areYouSure = await areYouSureDialog();
                    if (!areYouSure || !context.mounted) return;
                    context.read<TagsCubit>().deleteTags(selectedTagsIds);
                    await Future.delayed(const Duration(milliseconds: 300));
                    setState(() {
                      selectedTagsIds.removeWhere((element) => true);
                    });
                  },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocBuilder<TagsCubit, TagsState>(
        builder: (context, state) {
          if (state.status == DatabaseStatus.failure) {
            return const Center(
              child: Text('There was a failure loading your Lists'),
            );
          }

          return Expanded(
              child: ListView.builder(
            itemCount: state.tags.length,
            itemBuilder: (context, index) {
              final tag = state.tags[index];

              return ListTile(
                title: Text(tag.name),
                leading: Checkbox.adaptive(
                  value: selectedTagsIds.contains(tag.id),
                  onChanged: !tag.isModifiable
                      ? null
                      : (value) {
                          setState(() {
                            if (selectedTagsIds.contains(tag.id)) {
                              selectedTagsIds.removeWhere((id) => id == tag.id);
                            } else {
                              selectedTagsIds.add(tag.id);
                            }
                          });
                        },
                ),
                trailing: IconButton(
                  onPressed: !tag.isModifiable
                      ? null
                      : () async {
                          final newName = await showNameInputDialog(previousName: tag.name);
                          if (newName == null || !context.mounted) return;
                          context.read<TagsCubit>().updateTag(id: tag.id, newName: newName);
                        },
                  icon: const Icon(Icons.edit),
                ),
              );
            },
          ));
        },
      ),
    );
  }
}
