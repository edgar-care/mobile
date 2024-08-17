import 'package:edgar/styles/colors.dart';
import 'package:flutter/material.dart';

class Pagination extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const Pagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PaginationState createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.blue200, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (widget.currentPage > 1) {
                widget.onPageChanged(widget.currentPage - 1);
              }
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          const SizedBox(
            width: 16,
          ),
          if (widget.currentPage > 1) ...[
            GestureDetector(
              onTap: () {
                widget.onPageChanged(widget.currentPage - 1);
              },
              child: SizedBox(
                width: 22,
                child: Text((widget.currentPage - 1).toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black)),
              ),
            ),
          ] else ...[
            const SizedBox(
              width: 22,
            ),
          ],
          const SizedBox(
            width: 16,
          ),
          SizedBox(
            width: 22,
            child: Text(
              widget.currentPage.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                color: AppColors.blue700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          if (widget.currentPage < widget.totalPages) ...[
            GestureDetector(
              onTap: () {
                widget.onPageChanged(widget.currentPage + 1);
              },
              child: SizedBox(
                width: 22,
                child: Text((widget.currentPage + 1).toString(),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black)),
              ),
            ),
          ] else ...[
            const SizedBox(
              width: 22,
            ),
          ],
          const SizedBox(
            width: 16,
          ),
          GestureDetector(
            onTap: () {
              if (widget.currentPage < widget.totalPages) {
                widget.onPageChanged(widget.currentPage + 1);
              }
            },
            child: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
