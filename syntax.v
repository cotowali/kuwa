// Copyright 2022 The Kuwa Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module kuwa

pub type SyntaxKind = int

@[heap]
pub struct SyntaxNode {
	parent &SyntaxNode = unsafe { 0 }
	inner  InnerNodeElement
mut:
	offset usize
}

pub fn SyntaxNode.new_root(inner InnerNodeElement) SyntaxNode {
	return SyntaxNode{
		offset: 0
		inner: inner
	}
}

@[inline]
pub fn (node SyntaxNode) parent() ?&SyntaxNode {
	return if isnil(node.parent) { none } else { node.parent }
}

@[inline]
pub fn (node SyntaxNode) inner() InnerNodeElement {
	return node.inner
}

@[inlien]
pub fn (node SyntaxNode) offset() usize {
	return node.offset
}

pub fn (node &SyntaxNode) children() []SyntaxNode {
	mut offset := node.offset
	inner_children := node.inner.children()
	mut children := []SyntaxNode{len: inner_children.len}
	for i, inner in inner_children {
		children[i] = SyntaxNode{
			parent: node
			offset: offset
			inner: inner
		}
		offset += inner.text_len()
	}
	return children
}
