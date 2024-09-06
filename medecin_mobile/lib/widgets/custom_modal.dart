import 'package:edgar_pro/styles/colors.dart';
import 'package:flutter/material.dart';

enum ModalType {
  info,
  error,
  success,
}

class BottomSheetModel extends ChangeNotifier {
  int _currentPageIndex = 0;

  int get getCurrentPageIndex => _currentPageIndex;

  void resetCurrentIndex() {
    _currentPageIndex = 0;
    notifyListeners();
  }

  void changePage(int pageIndex) {
    _currentPageIndex = pageIndex;
    notifyListeners();
  }
}

class ListModal extends StatefulWidget {
  final List<Widget> children;
  final BottomSheetModel? model;
  const ListModal({super.key, required this.children, this.model});

  @override
  ListModalState createState() => ListModalState();
}

class ListModalState extends State<ListModal>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          margin: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widget.children.length; i++)
                if (widget.model != null)
                  Visibility(
                    visible: widget.model!.getCurrentPageIndex == i,
                    maintainState: true,
                    child: widget.children[i],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModalContainer extends StatelessWidget {
  /// Tittle of the modal
  final String title;

  /// Icon de la modal
  final Widget icon;

  /// Subtittle of the modal
  final String subtitle;

  /// The body of the modal
  final List<Widget>? body;

  /// The footer of the modal
  final Widget? footer;

  /// Required Tittle, subtittle, and Icon
  const ModalContainer ({
    super.key,
    required this.title,
    required this.subtitle,
    this.body,
    this.footer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        // padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.close),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                height: 1.5,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                height: 1.5,
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
              softWrap: true,
            ),
            if (body != null) ...[
              const SizedBox(height: 24),
              SingleChildScrollView(
                physics:
                    const BouncingScrollPhysics(), // Optional: Add bounce effect
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height -
                        264, // Adjust as needed
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: body!,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

class IconModal extends StatelessWidget {
  final Widget icon;
  final ModalType type;
  const IconModal({super.key, required this.icon, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: type == ModalType.info
            ? AppColors.blue100
            : type == ModalType.error
                ? AppColors.red200
                : AppColors.green200,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: icon,
    );
  }
}