const py = @cImport({
    @cDefine("PY_SSIZE_T_CLEAN", {});
    @cInclude("Python.h");
});
const std = @import("std");
const print = std.debug.print;

const PyObject = py.PyObject;
const PyMethodDef = py.PyMethodDef;
const PyModuleDef = py.PyModuleDef;
const PyModuleDef_Base = py.PyModuleDef_Base;
const Py_BuildValue = py.Py_BuildValue;
const PyModule_Create = py.PyModule_Create;
const METH_NOARGS = py.METH_NOARGS;
const PyArg_ParseTuple = py.PyArg_ParseTuple;
const PyLong_FromLong = py.PyLong_FromLong;

fn add(a: i64, b: i64) i64 {
    return a + b;
}

fn sum2(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;
    var py_list: *PyObject = undefined;

    // Parse the argument
    if (PyArg_ParseTuple(args, "O", &py_list) == 0) {
        return Py_BuildValue("");
    }

    // Check if the object is a list
    if (py.PyList_Check(py_list) == 0) {
        py.PyErr_SetString(py.PyExc_TypeError, "Input must be a list");
        return Py_BuildValue("");
    }

    // Get the length of the list
    const length: py.Py_ssize_t = py.PyList_Size(py_list);

    var s: c_long = 0;
    var i: py.Py_ssize_t = 0;
    // Iterate through the list
    while (i < length) : (i += 1) {
        const item: *PyObject = py.PyList_GetItem(py_list, i);

        // Check if the item is an integer
        if (py.PyLong_Check(item) == 1) {
            s += py.PyLong_AsLong(item);
        }
    }

    // Return the result as a Python object
    return PyLong_FromLong(s);
}

fn sum(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;
    var a: c_long = undefined;
    var b: c_long = undefined;
    if (!(py._PyArg_ParseTuple_SizeT(args, "ll", &a, &b) != 0)) return Py_BuildValue("");
    return py.PyLong_FromLong(add(a, b));
}

fn mul(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;
    var a: c_long = undefined;
    var b: c_long = undefined;
    if (PyArg_ParseTuple(args, "ll", &a, &b) == 0) return Py_BuildValue("");
    return PyLong_FromLong((a * b));
}

fn hello(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;
    _ = args;
    print("Welcome to ziglang!!!\n", .{});
    return Py_BuildValue("");
}

fn printSt(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;
    var input: [*:0]u8 = undefined;
    if (PyArg_ParseTuple(args, "s", &input) == 0) return Py_BuildValue("");
    print("You entered: {s}\n", .{input});
    return Py_BuildValue("");
}

fn returnArrayWithInput(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;

    var N: u32 = undefined;
    if (!(py._PyArg_ParseTuple_SizeT(args, "l", &N) != 0)) return Py_BuildValue("");
    const list: [*c]PyObject = py.PyList_New(N);

    var i: u32 = 0;
    while (i < N) : (i += 1) {
        const python_int: [*c]PyObject = Py_BuildValue("i", i);
        _ = py.PyList_SetItem(list, i, python_int);
    }
    return list;
}

var Methods = [_]PyMethodDef{
    PyMethodDef{
        .ml_name = "sum2",
        .ml_meth = sum2,
        .ml_flags = @as(c_int, 1),
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "sum",
        .ml_meth = sum,
        .ml_flags = @as(c_int, 1),
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "mul",
        .ml_meth = mul,
        .ml_flags = @as(c_int, 1),
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "hello",
        .ml_meth = hello,
        .ml_flags = METH_NOARGS,
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "printSt",
        .ml_meth = printSt,
        .ml_flags = @as(c_int, 1),
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "returnArrayWithInput",
        .ml_meth = returnArrayWithInput,
        .ml_flags = @as(c_int, 1),
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = null,
        .ml_meth = null,
        .ml_flags = 0,
        .ml_doc = null,
    },
};

var module = PyModuleDef{
    .m_base = PyModuleDef_Base{
        .ob_base = PyObject{
            .ob_refcnt = 1,
            .ob_type = null,
        },
        .m_init = null,
        .m_index = 0,
        .m_copy = null,
    },
    .m_name = "hoangdz",
    .m_doc = null,
    .m_size = -1,
    .m_methods = &Methods,
    .m_slots = null,
    .m_traverse = null,
    .m_clear = null,
    .m_free = null,
};

pub export fn PyInit_hoangdz() [*]PyObject {
    return PyModule_Create(&module);
}
